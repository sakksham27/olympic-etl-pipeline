/*
==================================================
Olympic Athlete Biography — Data Quality Checks
==================================================
*/

-- Data Sample preview
SELECT * 
FROM bronze.olympic_athlete_biography
LIMIT 100;

-- Check if athlete_id is purely numeric (will error if not)
SELECT athlete_id + 1 AS numeric_check
FROM bronze.olympic_athlete_biography;

-- Check for name formatting issues (extra spaces, wrong casing)
SELECT 
  name, 
  INITCAP(name) AS capitalized_name, 
  TRIM(name) AS trimmed_name
FROM bronze.olympic_athlete_biography
WHERE 
  name != INITCAP(name) OR
  name != TRIM(name);

-- Detect alphanumeric vs non-alphanumeric names
SELECT 
  CASE 
    WHEN name ~ '^[A-Za-z0-9]+$' THEN 'Alphanumeric'
    ELSE 'Non-Alphanumeric'
  END AS name_type,
  COUNT(*)
FROM bronze.olympic_athlete_biography
GROUP BY name_type;

-- Null check for name
SELECT name
FROM bronze.olympic_athlete_biography
WHERE name IS NULL;

-- ===============================================
-- Sex column checks

-- Trim test
SELECT sex
FROM bronze.olympic_athlete_biography
WHERE sex != TRIM(sex);

-- Capitalization check
SELECT sex, INITCAP(sex)
FROM bronze.olympic_athlete_biography
WHERE sex = INITCAP(sex);

-- Null check
SELECT sex 
FROM bronze.olympic_athlete_biography
WHERE sex IS NULL;

-- ===============================================
-- Born column: normalize various date formats

SELECT born, 
  CASE 
    WHEN LOWER(born) ~ '^[A-Za-z]{3,9} \d{4}$' THEN 
      TO_DATE(born, 'Month YYYY')::text
    WHEN LOWER(born) ~ '^\d{4}$' THEN  
      born::text
    WHEN LOWER(born) !~ '^[a-z0-9 ]+$' THEN  
      CASE 
        WHEN NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric > 2025 THEN 
          (NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric % 10000)::text
        ELSE 
          NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric::text
      END
    ELSE 
      TO_DATE(born, 'DD Month YYYY')::text
  END AS formatted_dob
FROM bronze.olympic_athlete_biography;

-- ===============================================
-- Height: check for non-numeric entries

SELECT height 
FROM bronze.olympic_athlete_biography
WHERE height::text !~ '^[0-9.]+$';

-- ===============================================
-- Weight: clean and normalize

-- Preview unclean weights
SELECT weight,
  CASE 
    WHEN weight !~ '^[0-9.]+$' THEN TRIM(weight::text)
    ELSE 'skip'
  END AS cleaned_weight
FROM bronze.olympic_athlete_biography;

-- Normalize weights with ranges like "55-65"
SELECT 
  b.weight, 
  CASE 
    WHEN b.weight !~ '^[0-9.]+$' THEN 
      ROUND(((m.matches)[1])::numeric + (m.matches)[3]::numeric) / 2
    ELSE 
      b.weight::numeric
  END AS formatted_weight
FROM bronze.olympic_athlete_biography AS b
LEFT JOIN LATERAL (
  SELECT regexp_matches(TRIM(b.weight::text), '(\d+)([^a-zA-Z0-9])(\d+)', 'g') AS matches
) m ON true;

-- ===============================================
-- Country column: whitespace and digit validation

-- Trim check
SELECT country, TRIM(country)
FROM bronze.olympic_athlete_biography
WHERE country != TRIM(country);

-- Detect invalid country values (only numbers or spaces)
SELECT country
FROM bronze.olympic_athlete_biography
WHERE TRIM(country) ~ '^[0-9 ]+$';

-- ===============================================
-- NOC (country_noc): should be exactly 3 characters
SELECT country_noc
FROM bronze.olympic_athlete_biography
WHERE LENGTH(country_noc) != 3;

-- ================================================
-- Final transformation for olympic_athlete_biography
SELECT 
athlete_id,
INITCAP(TRIM(name)) AS name,
CASE 
    WHEN LOWER(born) ~ '^[A-Za-z]{3,9} \d{4}$' THEN 
      TO_DATE(born, 'Month YYYY')::text
    WHEN LOWER(born) ~ '^\d{4}$' THEN  
      born::text
    WHEN LOWER(born) !~ '^[a-z0-9 ]+$' THEN  
      CASE 
        WHEN NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric > 2025 THEN 
          (NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric % 10000)::text
        ELSE 
          NULLIF(regexp_replace(born, '[^0-9]', '', 'g'), '')::numeric::text
      END
    ELSE 
      TO_DATE(born, 'DD Month YYYY')::text
  END AS born,
height,
CASE 
    WHEN b.weight !~ '^[0-9.]+$' THEN 
      ROUND(((m.matches)[1]::numeric + (m.matches)[3]::numeric)/ 2) 
    ELSE 
      b.weight::numeric
  END AS weight,
TRIM(country) AS country,
country_noc,
description
FROM bronze.olympic_athlete_biography as b
LEFT JOIN LATERAL (
  SELECT regexp_matches(TRIM(b.weight::text), '(\d+)([^a-zA-Z0-9])(\d+)', 'g') AS matches
) m ON true;

