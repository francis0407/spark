-- A test suite for ANY/SOME predicate subquery with JOINS in parent side, subquery, and both
-- It includes correlated cases.
-- List of configuration the test suite is run against:
--SET spark.sql.autoBroadcastJoinThreshold=10485760
--SET spark.sql.autoBroadcastJoinThreshold=-1,spark.sql.join.preferSortMergeJoin=true
--SET spark.sql.autoBroadcastJoinThreshold=-1,spark.sql.join.preferSortMergeJoin=false

create temporary view t1 as select * from values
  ("val1a", 6S, 8, 10L, float(15.0), 20D, 20E2, timestamp '2014-04-04 01:00:00.000', date '2014-04-04'),
  ("val1b", 8S, 16, 19L, float(17.0), 25D, 26E2, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("val1a", 16S, 12, 21L, float(15.0), 20D, 20E2, timestamp '2014-06-04 01:02:00.001', date '2014-06-04'),
  ("val1a", 16S, 12, 10L, float(15.0), 20D, 20E2, timestamp '2014-07-04 01:01:00.000', date '2014-07-04'),
  ("val1c", 8S, 16, 19L, float(17.0), 25D, 26E2, timestamp '2014-05-04 01:02:00.001', date '2014-05-05'),
  ("val1d", null, 16, 22L, float(17.0), 25D, 26E2, timestamp '2014-06-04 01:01:00.000', null),
  ("val1d", null, 16, 19L, float(17.0), 25D, 26E2, timestamp '2014-07-04 01:02:00.001', null),
  ("val1e", 10S, null, 25L, float(17.0), 25D, 26E2, timestamp '2014-08-04 01:01:00.000', date '2014-08-04'),
  ("val1e", 10S, null, 19L, float(17.0), 25D, 26E2, timestamp '2014-09-04 01:02:00.001', date '2014-09-04'),
  ("val1d", 10S, null, 12L, float(17.0), 25D, 26E2, timestamp '2015-05-04 01:01:00.000', date '2015-05-04'),
  ("val1a", 6S, 8, 10L, float(15.0), 20D, 20E2, timestamp '2014-04-04 01:02:00.001', date '2014-04-04'),
  ("val1e", 10S, null, 19L, float(17.0), 25D, 26E2, timestamp '2014-05-04 01:01:00.000', date '2014-05-04')
  as t1(t1a, t1b, t1c, t1d, t1e, t1f, t1g, t1h, t1i);

create temporary view t2 as select * from values
  ("val2a", 6S, 12, 14L, float(15), 20D, 20E2, timestamp '2014-04-04 01:01:00.000', date '2014-04-04'),
  ("val1b", 10S, 12, 19L, float(17), 25D, 26E2, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("val1b", 8S, 16, 119L, float(17), 25D, 26E2, timestamp '2015-05-04 01:01:00.000', date '2015-05-04'),
  ("val1c", 12S, 16, 219L, float(17), 25D, 26E2, timestamp '2016-05-04 01:01:00.000', date '2016-05-04'),
  ("val1b", null, 16, 319L, float(17), 25D, 26E2, timestamp '2017-05-04 01:01:00.000', null),
  ("val2e", 8S, null, 419L, float(17), 25D, 26E2, timestamp '2014-06-04 01:01:00.000', date '2014-06-04'),
  ("val1f", 19S, null, 519L, float(17), 25D, 26E2, timestamp '2014-05-04 01:01:00.000', date '2014-05-04'),
  ("val1b", 10S, 12, 19L, float(17), 25D, 26E2, timestamp '2014-06-04 01:01:00.000', date '2014-06-04'),
  ("val1b", 8S, 16, 19L, float(17), 25D, 26E2, timestamp '2014-07-04 01:01:00.000', date '2014-07-04'),
  ("val1c", 12S, 16, 19L, float(17), 25D, 26E2, timestamp '2014-08-04 01:01:00.000', date '2014-08-05'),
  ("val1e", 8S, null, 19L, float(17), 25D, 26E2, timestamp '2014-09-04 01:01:00.000', date '2014-09-04'),
  ("val1f", 19S, null, 19L, float(17), 25D, 26E2, timestamp '2014-10-04 01:01:00.000', date '2014-10-04'),
  ("val1b", null, 16, 19L, float(17), 25D, 26E2, timestamp '2014-05-04 01:01:00.000', null)
  as t2(t2a, t2b, t2c, t2d, t2e, t2f, t2g, t2h, t2i);

create temporary view t3 as select * from values
  ("val3a", 6S, 12, 110L, float(15), 20D, 20E2, timestamp '2014-04-04 01:02:00.000', date '2014-04-04'),
  ("val3a", 6S, 12, 10L, float(15), 20D, 20E2, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("val1b", 10S, 12, 219L, float(17), 25D, 26E2, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("val1b", 10S, 12, 19L, float(17), 25D, 26E2, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("val1b", 8S, 16, 319L, float(17), 25D, 26E2, timestamp '2014-06-04 01:02:00.000', date '2014-06-04'),
  ("val1b", 8S, 16, 19L, float(17), 25D, 26E2, timestamp '2014-07-04 01:02:00.000', date '2014-07-04'),
  ("val3c", 17S, 16, 519L, float(17), 25D, 26E2, timestamp '2014-08-04 01:02:00.000', date '2014-08-04'),
  ("val3c", 17S, 16, 19L, float(17), 25D, 26E2, timestamp '2014-09-04 01:02:00.000', date '2014-09-05'),
  ("val1b", null, 16, 419L, float(17), 25D, 26E2, timestamp '2014-10-04 01:02:00.000', null),
  ("val1b", null, 16, 19L, float(17), 25D, 26E2, timestamp '2014-11-04 01:02:00.000', null),
  ("val3b", 8S, null, 719L, float(17), 25D, 26E2, timestamp '2014-05-04 01:02:00.000', date '2014-05-04'),
  ("val3b", 8S, null, 19L, float(17), 25D, 26E2, timestamp '2015-05-04 01:02:00.000', date '2015-05-04')
  as t3(t3a, t3b, t3c, t3d, t3e, t3f, t3g, t3h, t3i);

-- TC 01.01
SELECT t1a,
       t1b,
       t1c,
       t2a,
       t2b,
       t2c
FROM   t1
JOIN   t2
ON     t1a = t2a
WHERE  t2b < ANY (SELECT t3b
                  FROM   t3
                  WHERE  t3b <= 10
                  AND    t3c <= t2c);

-- TC 01.02
SELECT t1a,
       t1b,
       t1c,
       t1d
FROM   t1
WHERE  t1b > ANY (SELECT t2b
                  FROM   t2,
                         t3
                  WHERE  t2a = t3a
                  AND    t2b > t3b)
AND    t1d > 10;

-- TC 01.03
SELECT   t1a,
         t3a,
         Count(*)
FROM     t1,
         t3
WHERE    t1a = ANY (SELECT t2a
                    FROM   t2
                    WHERE  t1b >= t2b)
AND      t1c = t3c
GROUP BY t1a,
         t3a
ORDER BY t1a DESC, t3a DESC;

-- TC 01.04
SELECT   t1a,
         t2a,
         SUM(t1c)
FROM     t1 FULL OUTER
JOIN     t2
ON       t1b = t2b
WHERE    t1a >= ANY (SELECT t3a
                     FROM   t3
                     WHERE  t3b > 6)
OR       t1a <= ANY (SELECT t3a
                     FROM   t3
                     WHERE  t3d < 100)
GROUP BY t1a,
         t2a
HAVING   SUM(t1c) IS NOT NULL
AND      t2a IS NOT NULL
ORDER BY t1a;

-- TC 01.05
SELECT      t1a,
            COUNT(*)
FROM        t1
INNER JOIN  t2
ON          t1a = t2a
WHERE       t2b < ANY (SELECT t3b
                       FROM   t2 LEFT OUTER
                       JOIN   t3
                       ON     t2b = t3b
                       AND    t2c >= t3c)
GROUP BY    t1a;

-- TC 01.06
SELECT      t1a
FROM        t1
RIGHT JOIN  t3
ON          t1c > t3c
WHERE       t1a = ANY (SELECT   t2a
                       FROM     t2
                       WHERE    t2b IS NOT NULL
                       GROUP BY t2a)
AND         t1b > t3b
GROUP BY    t1a
ORDER BY    t1a;

-- TC 01.07
SELECT   Count(t1a),
         t1b
FROM     t1
WHERE    t1a >= ANY (SELECT  t2a
                     FROM    t2
                     JOIN    t1
                     ON      t2b <> t1b)
AND      t1h <= ANY (SELECT     t2h
                     FROM       t2
                     RIGHT JOIN t3
                     ON         t2b = t3b)
GROUP BY t1b
HAVING   t1b > 8;

-- TC 01.08
SELECT   Count(DISTINCT(t1a)),
         t1b
FROM     t1
WHERE    t1a != ANY (SELECT  t2a
                     FROM    t2
                     JOIN    t1
                     ON      t2b <> t1b)
AND      t1h >= ANY (SELECT     t2h
                     FROM       t2
                     RIGHT JOIN t3
                     ON         t2b = t3b)
AND      t1b > ANY  (SELECT  t2b
                     FROM    t2  FULL OUTER
                     JOIN    t3
                     ON      t2b = t3b)

GROUP BY t1b
HAVING   t1b > 8;

-- TC 01.09
SELECT     Count(DISTINCT(t1a)),
           t1b
FROM       t1
INNER JOIN t2 ON t1b = t2b
RIGHT JOIN t3 ON t1a = t3a
where      t1a >= ANY (SELECT          t2a
                       FROM            t2
                       FULL OUTER JOIN t3
                       ON              t2b > t3b)
AND        t1c <= ANY (SELECT          t3c
                       FROM            t3
                       LEFT OUTER JOIN t2
                       ON              t3a = t2a )
AND        t1b <= ANY (SELECT t3b
                       FROM   t3 LEFT OUTER
                       JOIN   t1
                       ON     t3c = t1c)
AND        t1a = t2a
GROUP BY   t1b
ORDER BY   t1b DESC;

-- TC 01.10
SELECT     t1a,
           t1b,
           t1c,
           COUNT(DISTINCT(t2a)),
           t2b,
           t2c
FROM       t1
FULL JOIN  t2  ON t1a = t2a
RIGHT JOIN t3  ON t1a = t3a
WHERE      t1a >= ANY (SELECT t2a
                       FROM   t2 INNER
                       JOIN   t3
                       ON     t2b < t3b
                       WHERE  t2c != ANY (SELECT t1c
                                          FROM   t1
                                          WHERE  t1a = t2a))
AND        t1a = t2a
Group By   t1a, t1b, t1c, t2a, t2b, t2c
HAVING     t2c IS NOT NULL
ORDER By   t2b DESC nulls last;
