-- 2. `orders`테이블에서 `id` 가 `423`인 주문을 조회하세요.

SELECT * FROM orders WHERE id = 423;
 id  |    date    |   time   
-----+------------+----------
 423 | 2025-01-07 | 19:45:07



-- 3. `orders` 테이블에서 총 주문 건수를 `total_orders`라는 이름으로 구하세요.

-- FIX: SELECT COUNT(*) AS total_orders 누락 
SELECT COUNT(*) AS total_orders FROM orders;
 total_orders 
--------------
        21350
(1 row)

-- 4. `orders` 테이블에서 최신 순으로 주문을 조회하세요. (`date`, `time` 컬럼이 분리되어 있다는 점에 주의)
SELECT * FROM orders ORDER BY date DESC, time DESC;


-- 5. `orders` 테이블에서 오프셋 기반 페이지네이션된 목록을 조회합니다. 페이지 크기가 10이고 최신순일 때, 첫 번째 페이지를 조회하세요.
 id |    date    |   time   
----+------------+----------
  2 | 2025-01-01 | 11:57:40
  3 | 2025-01-01 | 12:12:28
  4 | 2025-01-01 | 12:16:31
  5 | 2025-01-01 | 12:21:30
  6 | 2025-01-01 | 12:29:36
  7 | 2025-01-01 | 12:50:37
  8 | 2025-01-01 | 12:51:37
  9 | 2025-01-01 | 12:52:01
 10 | 2025-01-01 | 13:00:15
  1 | 2025-01-01 | 11:38:36



-- 6. `orders` 테이블에서 오프셋 기반 페이지네이션된 목록을 조회합니다. 페이지 크기가 10이고 최신순일 때 5번째 페이지를 조회하세요.
-- OFFSET = 10 * (page - 1)
-- 0 / 1,2,3,4,5,6,7,8,9,10 -- 1 p
-- 10 / 11,12,13,14,15,16,17,18,19,20 -- 2p
-- 20 / 21,22,23,24,25,26,27,28,29,30 -- 3p
-- 30 / 31,32,33,34,35,36,37,38,39,40 -- 4p
-- 40 / 41,42,43,44,45,46,47,48,49,50 -- 5p

-- FIX: OFFSET 4 ->  40 누락 
SELECT * FROM orders ORDER BY date DESC, time DESC LIMIT 10 OFFSET 40;

-- 8. `orders` 테이블에서 2025년 3월에 주문된 내역만 조회하세요.
 
-- FIX: 다음과 같이 수정.
SELECT * FROM orders WHERE date >= '2025-03-01' AND date < '2025-04-01';


-- 9. `orders` 테이블에서 2025년 3월 12일 오전에 주문된 내역만 조회하세요.

-- Recommendation: 부등호 사용해도 괜찮음.
-- timestamptz로 하는 것도 나쁘지 않음.
SELECT * 
FROM orders
WHERE (date + time)
BETWEEN '2025-03-12 08:00:00'::timestamp AND '2025-03-12 12:00:00'::timestamp;


-- 10. `pizza_types` 테이블에서 이름에 'Cheese' 혹은 'Chicken'이 포함된 피자 종류를 조회하세요. (대소문자를 구분합니다)

-- FIX: ingredients -> name 수정
-- ILIKE와 LIKE 차이 공부해보기
SELECT name 
FROM pizza_types
WHERE name LIKE '%Cheese%' OR name LIKE '%Chicken%'
;


-- 중급?

 -- 1. `order_details` 테이블에서 각 피자(`pizza_id`)별로 주문된 건 수(`order_id`)를 보여주세요.

-- 피자 아이디를 기준으로 주문된 건수 

-- FIX: COUNT(order_id) -> COUNT(DISTINCT order_id) 수정
-- order_id 하나에 대해 같은 피자가 여러개일 수 있음...

SELECT pizza_id, COUNT(DISTINCT order_id)
FROM order_details
GROUP BY pizza_id
;

 -- 2. `order_details` 테이블에서 각 피자(`pizza_id`)별로 총 주문 수량을 구하세요.
-- pizza id를 기준으로 총 주문 수량구하기



 pizza_id    |   sum    
----------------+----------
 mexicana_m     |  4910266
 napolitana_s   |  5006550
 mediterraneo_m |  3074130
 spinach_supr_m |  2839800
 ital_veggie_s  |  3116388



 -- 4. `orders` 테이블에서 각 날짜별 총 주문 건수를 `order_count` 라는 이름으로 계산하고, 하루 총 주문 건수가 80건 이상인 날짜만 조회한 뒤, 주문 건수가 많은 순서대로 정렬하세요.

-- 서브쿼리로 풀어도 됨
SELECT date, COUNT(id) AS order_count
FROM orders
GROUP BY date
HAVING COUNT(id) >= 80
ORDER BY order_count DESC;

 -- 5. `order_details` 테이블에서 피자별(`pizza_id`) 총 주문 수량이 10개 이상인 피자만 조회하고, 총 주문 수량 기준으로 내림차순 정렬하세요.


-- `order_details` 테이블에서 피자별(`pizza_id`) 총 주문 수량이 10개 이상인 피자만 조회하고, 

     -- SELECT pizza_id,  COUNT(order_id)  AS order_cnt

     -- FROM order_details

-- ->  총 주문 수량이 10개 이상인 피자만 조회하고, 
    HAVING  order_cnt >= 10

-- ->  피자별(`pizza_id`)
    GROUP BY pizza_id


-- 총 주문 수량 기준으로 내림차순 정렬하세요.
-- ORDER BY order_cnt DESC

-- FIX: COUNT(order_id) -> SUM(quantity) 수정    

SELECT pizza_id, SUM(quantity) AS order_cnt
FROM order_details
GROUP BY pizza_id
HAVING SUM(quantity) >= 10
ORDER BY order_cnt DESC;




-- 6. `order_details` 테이블에서 피자별 총 수익을 `total_revenue` 라는 이름으로 구하세요. (수익 = `quantity * price`)


/*-  `order_details` 테이블에서 피자별 
    
   - 피자별 총수익 -> pizza id 을 기준점에 넣은 다음 order detail에 있는 pizza quantity를 가지고 온다
   SELECT pizza_id, FROM order_details 
   
   - GROUP BY로 피자 id 로 그룹화 한다

- 총 수익을  `total_revenue` 라는 이름으로 구하세요. (수익 = `quantity * price`)


    -  (quantity * price)를 기준점에 추가 한다. 
    이때 피자 가격 pizzas에 칼럼으로 존재 하므로, order detail에 id 값이 pizzas.id 존재 유무를 확인 한다음  계산 하기
    -  (quantity * price)를  total_revenue 별칭으로 설정 해둔다

*/

SELECT pizza_id, SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
INNER JOIN pizzas p on od.pizza_id = p.id
GROUP BY pizza_id
ORDER BY total_revenue DESC


-- 7. 날짜별로 피자 주문 건수(`order_count`)와 총 주문 수량(`total_quantity`)을 구하세요.

/*
order - (**id**, date, time)  =  orderdetails - (orderid,**id**, quantity, pizza_id)  


- 날짜별로
    - 날짜를 기준점을 잡는다

        - orders 모델에 있는 날짜 필드를 가지고 온다


    - 피자 주문 건수(`order_count`)

        - orders에 있는 주문건수(id 필드)를 기준점에 추가하고  주문건수에 별칭을 설정한다


    - GROUP BY로 날짜로 설정한다

    - 총 주문 수량(`total_quantity`)을 구하세요.


        - 기준점에 총 주문량을 추가한다음  별칭을 설정한다. 

*/

-- DISTINCT: 참고로 이거 쿼리 성능에 영향을 줄 때가 많아서 조심히 써야함.. 쿼리튜닝 or 설계 자체를 수정하거나

SELECT o.date, COUNT(DISTINCT o.id) AS order_count, SUM(od.quantity) AS total_quantity
FROM orders o
INNER JOIN order_details od ON o.id = od.order_id
GROUP BY o.date;


/*1. 피자별(`pizzas.id` 기준) 판매 수량 순위에서 피자별 판매 수량 상위에 드는 베스트 피자를 10개를 조회해 주세요. `pizzas`의 모든 컬럼을 조회하면서 각 피자에 해당하는 판매량을 `total_quantity`라는 이름으로 함께 조회합니다.

    pizzas - (**id**| type_id | size | price )   < - > order details - ( (orderid, id, quantity, **pizza_id**)  ) 


-  피자별(`pizzas.id` 기준) 판매 수량 순위에서 피자별 판매 수량 상위에 드는 베스트 피자를 10개를 조회해 주세요.

    - 피자별(`pizzas.id` 기준) 
    SELECT pizza.id
    FROM pizzas p

    GROUP BY p

    - 판매 수량 순위 best pizza 10개 (LIMIT)
      SELECT pizza.id, SUM(p.quantity) AS total_quantity

      LIMIT 10
      ORDER BY COUNT(total_quantity) DESC



- `pizzas`의 모든 컬럼을 조회하면서 각 피자에 해당하는 판매량을 `total_quantity`라는 이름으로 함께 조회합니다.
    - `pizzas`의 모든 컬럼을 조회
    
    SELECT *  FROM pizzas p

    - total_quantity 기준점 추가후 각피자에 대한 판매량 조회 

    INNER JOIN order_details od ON od.id = p.id

*/

-- DESC 추가

SELECT p.*, SUM(od.quantity) AS total_quantity
FROM pizzas p
INNER JOIN order_details od ON p.id = od.pizza_id 
GROUP BY p.id 
ORDER BY total_quantity DESC
LIMIT 10;
/*

## MISTAKE:
INNER JOIN order_details od ON p.id = od.pizza_id

INNER JOIN 은 공통된 데이터를 칼럼 내에 찾는거임. 근데 난 p.id가 정수로 착각해서 od.id라고 씀.. 그래서 그런지 문자열 비교 가 안됬음.
*/


/*
 2. `orders` 테이블에서 2025년 3월의 일별 주문 수량을 `total_orders`라는 이름으로, 일별 총 주문 금액을 `total_amount`라는 이름으로 포함해서 조회하세요.
    order( id, date) -> order_detail(quantity) -> pizzas(price)

- `orders` 테이블에서 
    FROM orders o

    - 3월의 일별 주문 수량을 `total_orders

    SELECT o.date, SUM(od.quantity) AS total_orders
    FROM order o
    LEFT JOIN order_details od ON o.id = or.order_id
    GROUP BY total_orders
    

    - 일별 총 주문 금액을 `total_amount`라는 이름으로 포함해서 조회하세요.
    SELECT o.date, SUM(od.quantity) AS total_orders, SUM(p.price * od.quantity) AS total_amount;
    FROM order o
    LEFT JOIN order_details od ON o.id = or.order_id
    INNER JOIN pizzas p on or.id = p.id
    GROUP BY o.date
    
*/

-- total orders 수정 및
-- 3월 필터 추가해야함.
SELECT o.date, COUNT(DISTINCT o.id) AS total_orders, SUM(p.price * od.quantity) AS total_amount
    FROM orders o 
    INNER JOIN order_details od ON o.id = od.order_id
    INNER JOIN pizzas p ON od.pizza_id = p.id
    WHERE o.dtae >= '2025-03-01' AND o.dtae < '2025-04-01'
    GROUP BY o.date
     
;
    date    | total_orders |    total_amount    
------------+--------------+--------------------
 2025-11-24 |          131 |  2230.050001144409
 2025-03-31 |          161 | 2756.6000022888184
 2025-02-16 |          119 | 1968.8000030517578
 2025-10-22 |          145 | 2400.9000034332275
 2025-08-05 |          130 | 2094.8500022888184
 2025-05-22 |          154 | 2635.1000022888184
 2025-04-20 |          151 | 2459.4500007629395
 2025-12-01 |          131 | 2076.7000045776367
 2025-10-31 |          165 | 2744.8500003814697

 /*
 ## MISTAKES 

- 별칭 까먹음..
해당 문제를 잘게 잘게 썰어서 보면서 실수로 별칭을 안썼음,.... AS 쓰자,......
 */

/*
  3. `order`의 `id`가 78에 해당하는 주문 내역들을 조회합니다. 주문 내역에서 각각 주문한 피자의 이름을 `pizza_name`, 
  피자의 크기를 `pizza_size`, 피자 가격을 `pizza_price`, 수량을 `quantity`, 각 주문 내역의 총 금액을 `total_amount` 라는 이름으로 조회해 주세요.
        
    orderdetails = (id, quantity, order_id, pizza_id)

    pizzas = (id, type_id, size, price )                                                  

  
  -`order`의 `id`가 78에 해당하는 주문 내역들을 조회합니다.
    SELECT p.*, o.* WHERE id = 78 

    FROM order
  - 주문 내역에서 해당 부분으로 조회해 주세요.
    -  pizza_name, pizza_size, pizza_price, quantity

    LEFT JOIN pizzas p ON o.id = p.id

    - 

    - pizza_price, quantity
  
     INNER JOIN order_details od = o.id = od.order_id 
    -   total_amount
my approach thought 

SELECT p.*, o.*, SUM(od.quantity * p.price ) AS total_amount
FROM orders o
LEFT JOIN order_details od  ON o.id = od.order_id
INNER JOIN pizzas p ON p.id = od.pizza_id
WHERE id = 78 ;
*/

-- FIX: pizza_types 조인 추가
SELECT 
    pt.name AS pizza_name,
    p.size AS pizza_size,
    p.price AS pizza_price,
    od.quantity,
    (p.price * od.quantity) AS total_amount
FROM orders o
INNER JOIN order_details od ON o.id = od.order_id
INNER JOIN pizzas p ON p.id = od.pizza_id
INNER JOIN pizza_types AS pt ON p.type_id = pt.id
WHERE o.id = 78;


/*
  4. `order_details`와 `pizzas` 테이블을 JOIN해서 피자 크기별(S, M, L) 총 수익을 계산하고, 크기별 수익을 출력하세요.
        

-`order_details`와 `pizzas` 테이블을 JOIN 
FROM order_details od
INNER JOIN pizzas p ON od.pizza_id = p.id


- 피자 크기별(S, M, L) 총 수익을 계산하고
SELECT p.size, SUM(od.quantity * p.price) AS profit
GROUP BY p.size


- 크기별 수익을 출력하세요.
ORDER BY 
    CASE p.size
     {
        WHEN 'S' THEN 1 
        WHEN 'M' THEN 2 
        WHEN 'L' THEN 3 
    }
*/

SELECT p.size, SUM(od.quantity * p.price) AS profit
FROM order_details od
INNER JOIN pizzas p ON od.pizza_id = p.id
GROUP BY p.size
ORDER BY 
    CASE p.size

        WHEN 'S' THEN 1 
        WHEN 'M' THEN 2 
        WHEN 'L' THEN 3 
        WHEN 'XL' THEN 4  -- 추가
        WHEN 'XXL' THEN 5  -- 추가
    
    END;




 size |       profit       
------+--------------------
 S    | 178076.49981307983
 M    |          249382.25
 L    |  375318.7010040283
 XL   |              14076
 XXL  | 1006.6000213623047

/*
# MISTAKES 

- ORDER BY:
    pizzas내에 있는 사이즈 순서대로  나타내는 부분에서 어려움을 겪음.
    WHEN "S" THEN 1


- JOIN :

음 조인에 대한 개념이 부족했음. LEFT, RIGHT 조인을 쓴다면 어디가 기준이 되어야 하는 지, 어느 값이 나올지에 대한 어려움이었던 거였음. 조인이     `A n B` 인건 알고 있었음,, 만약에 LEFT 기준이라면 A - B + (A n B),  right 기준 B - A + (A n B). 만약에 오른쪽에 NULL 이 생긴다 ? LEFT JOIN. 
*/

-- 5. `order_details`, `pizzas`, `pizza_types` 테이블을 JOIN해서 각 피자 종류의 총 수익을 계산하고, 수익이 높은 순서대로 출력하세요.




-- `order_details`, `pizzas`, `pizza_types` 테이블을 JOIN 해서 각 피자 종류의 총 수익을 계산하고,
SELECT pt.name AS name, SUM(od.quantity * p.price) AS profit
FROM pizzas p
LEFT JOIN order_details od ON p.id = od.pizza_id
INNER JOIN pizza_types pt ON p.type_id = pt.id
GROUP BY pt.name
ORDER BY profit DESC;

-  수익이 높은 순서대로 출력하세요.



잘못 생각했던 로직:
NNER JOIN pizza_types pt ON p.type_id = pt.id
첨에는 p.id = pt.id 라고 씀. 피자 종류 는 종류끼리 이어줘야하는데 잘못된 접근 이었음


GROUP BY pt.name
집계 함수를 쓴다면 GROUP BY 함수는 필수임... pt.name 을 기준으로 집계..

 