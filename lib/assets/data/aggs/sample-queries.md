# Aggregation queries on BTS T100 data


##### Select busiest airports based on post-2004 traffic, add ourairports data

```sql
select count(1) as record_count, sum(`PASSENGERS`) total_passengers, ORIGIN_AIRPORT_ID as origin_airport_dot_id, 
  ORIGIN as origin_airport_iata, ORIGIN_CITY_NAME, `ORIGIN_STATE_ABR`, ORIGIN_WAC,
  t2.type AS airport_type,
  t2.latitude_deg AS latitude,
  t2.longitude_deg AS longitude,
  t2.iso_country AS iso_country,
  t2.iso_region AS iso_region,
  t2.gps_code AS gps_code,
  t2.local_code AS local_code,
  t2.continent AS continent,
  t2.elevation_ft AS elevation_feet

from t100_all
INNER JOIN ourairports AS t2
  ON t2.iata_code = ORIGIN

WHERE year > 2004
group by origin_airport_dot_id
order by total_passengers desc
```



### Filtering the master database

Run these queries to filter out records from the master database

##### Select records that involve one of the top 30 carriers

```sql
SELECT t.* 
FROM t100_all AS t
INNER JOIN
  ( SELECT unique_carrier_code FROM top_carriers ORDER BY total_passengers DESC LIMIT 30) AS x    
  ON t.unique_carrier = x.unique_carrier_code
ORDER BY
  unique_carrier_code, year, month, `AIRCRAFT_TYPE`
```


##### Non-dynamic version (post 2004)

```sql
select * from t100_all
WHERE unique_carrier
IN("DL", "AA", "WN", "UA", "US", "NW", "CO", "AS", "HP", "TW", "MQ", "FL", "B6", "OO", "EV", "XE", "HA", "BA", "QX", "YV", "F9", "AC", "9E", "OH", "ZW", "NK", "TZ", "KH", "LH", "XJ")
AND year >= 2004

ORDER BY
  unique_carrier, year, month, `AIRCRAFT_TYPE`
```

##### Select records that involve one of the top 150 airports

```sql
SELECT t.* 
FROM t100_all AS t
INNER JOIN
  ( SELECT airport_id FROM top_airports ORDER BY total_passengers DESC LIMIT 150) AS x
    
  ON t.ORIGIN_AIRPORT_ID = x.origin_airport_dot_id
ORDER BY
  origin_airport_iata, year, month, `unique_carrier` `AIRCRAFT_TYPE`
```
