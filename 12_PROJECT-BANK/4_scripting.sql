USE bank;

-- главное представление кредитного модуля любого банка: подробный кредитный портфель
-- !!! Возможны повторы наименований!!! Фейкер немного подвел :(
CREATE VIEW loans_view AS 
SELECT 
	clients.name 'Заемщик',
	clients.inn 'ИНН заемщика',
	contracts.`date` 'Дата выдачи кредита',
	contracts.date_end 'Дата окончания кредита',
	a.acc_val 'Текущий долг',
	b.acc_val 'Резерв по текущему долгу',
	c.acc_val 'Просроченный долг',
	d.acc_val 'Резерв по просроченному долгу',
	e.acc_val 'Текущие проценты',
	f.acc_val 'Резерв по текущим процентам',
	g.acc_val 'Просроченные проценты',
	h.acc_val 'Резерв по просроченным процентам',
	i.acc_val 'Обеспечение',
	k.take_coverage 'Принимается ли обеспечение',
	k.quality '% расчетного резерва',
	k.analytics 'Анализ'
FROM loans l
LEFT JOIN accounts a 
	ON l.current_debt_id = a.id
LEFT JOIN accounts b
	ON l.current_debt_reserve_id = b.id
LEFT JOIN accounts c
	ON l.overdue_debt_id = c.id
LEFT JOIN accounts d
	ON l.overdue_debt_reserve_id = d.id
LEFT JOIN accounts e 
	ON l.current_percent_id = e.id
LEFT JOIN accounts f
	ON l.current_percent_reserve_id = f.id
LEFT JOIN accounts g 
	ON l.overdue_percent_id = g.id
LEFT JOIN accounts h
	ON l.overdue_percent_reserve_id = h.id
LEFT JOIN accounts i
	ON l.coverage_id = i.id
LEFT JOIN reports k
	ON l.report_id = k.id
LEFT JOIN contracts
	ON l.contract_id = contracts.id
LEFT JOIN clients
	ON contracts.client_id = clients.id;

SELECT * FROM loans_view LIMIT 15;
-- Вывод:
-- |Заемщик                      |ИНН заемщика|Дата выдачи кредита|Дата окончания кредита|Текущий долг        |Резерв по текущему долгу|Просроченный долг   |Резерв по просроченному долгу|Текущие проценты    |Резерв по текущим процентам|Просроченные проценты|Резерв по просроченным процентам|Обеспечение         |Принимается ли обеспечение|% расчетного резерва|Анализ                                               |
-- |-----------------------------|------------|-------------------|----------------------|--------------------|------------------------|--------------------|-----------------------------|--------------------|---------------------------|---------------------|--------------------------------|--------------------|--------------------------|--------------------|-----------------------------------------------------|
-- |ООО " LG пеццолайо "         |7737465684  |2021-09-20         |2009-07-20            |                    |                        |200000              |3140                         |                    |                           |4044                 |63                              |                    |0                         |3.85                |Eaglet, and several other curious creatures. Alice   |
-- |ПАО " анкистрон навигатор "  |7745959419  |2014-12-20         |2025-10-20            |                    |                        |1520641             |1520641                      |                    |                           |74457                |74457                           |                    |0                         |100.00              |The Queen smiled and passed on. Who ARE you talki    |
-- |ООО " автокухня судомойка "  |7734433045  |2002-10-20         |2025-09-20            |                    |                        |753471              |753471                       |                    |                           |55501                |55501                           |200000              |1                         |2.90                |Between yourself and me. Thats the reason of th      |
-- |АО " азиатчина повечерие "   |7732205524  |2011-07-20         |2005-07-20            |                    |                        |470587              |470587                       |                    |                           |13694                |13694                           |300000              |1                         |52.47               |What made you so awfully clever? I have answered     |
-- |АО " азиатчина повечерие "   |7732205524  |2027-10-20         |2016-10-20            |                    |                        |1440851             |1440851                      |                    |                           |62927                |62927                           |2880000             |1                         |3.90                |The poor little thing howled so, that Alice had be   |
-- |АО " азиатчина повечерие "   |7732205524  |2021-08-20         |2017-08-20            |                    |                        |3487500             |3487500                      |                    |                           |163275               |163275                          |3135600             |1                         |100.00              |Mock Turtle, they--youve seen them, of course?       |
-- |ООО " адипометр массажист "  |7756568650  |2020-12-20         |2018-12-20            |                    |                        |3000000             |3000000                      |                    |                           |172951               |172951                          |                    |0                         |2.90                |Alice. Im glad theyve begun asking riddles.--I       |
-- |АО " азоогения ландкарта "   |7799769465  |2004-09-20         |2021-08-20            |                    |                        |77076               |77076                        |                    |                           |5708                 |5708                            |                    |0                         |20.00               |Rabbit was still in sight, hurrying down it. There   |
-- |ООО " аллилиден полиплекс "  |7722165617  |2008-10-20         |2030-09-20            |                    |                        |709000              |709000                       |                    |                           |35813                |35813                           |666500              |1                         |1.57                |Do you think, at your age, it is I hate cats and d   |
-- |ООО " альстонит пирозамок "  |7728880836  |2028-07-20         |2012-07-20            |                    |                        |1320000             |1320000                      |                    |                           |114777               |114777                          |815000              |1                         |3.85                |Alice, surprised at her side. She was walking hand   |
-- |ООО " авиатариф фрюктидор "  |7739896081  |2025-05-20         |2008-05-20            |                    |                        |999356              |999356                       |                    |                           |22647                |22647                           |1968500             |1                         |25.35               |Come here directly, and get ready to talk about wa   |
-- |ООО " авиатариф фрюктидор "  |7739896081  |2025-10-20         |2024-10-20            |                    |                        |116966              |116966                       |                    |                           |18859                |18859                           |775000              |1                         |2.90                |Williams conduct at first was in the middle. Alic    |
-- |АО " аккордион пуходерка "   |7720928889  |2023-08-20         |2014-08-20            |                    |                        |688246              |361123                       |                    |                           |67855                |35604                           |350000              |1                         |1.19                |Dormouse followed him: the March Hare. I didnt k     |
-- |ПАО " анкарамит цинерария "  |7765119133  |2001-03-20         |2025-02-20            |                    |                        |186602              |186602                       |                    |                           |13306                |13306                           |200000              |1                         |35.60               |And then a row of lamps hanging from the time they   |
-- |ООО " алкандиол разломщик "  |7748459253  |2007-06-20         |2006-06-20            |                    |                        |68321               |68321                        |                    |                           |28504                |28504                           |                    |0                         |1.19                |Good-bye, feet! (for when she had asked it aloud;    |



-- Функция по определению категории качества кредита
DELIMITER //
CREATE FUNCTION GetCategory (r DECIMAL(5, 2))         
    RETURNS TINYINT NO SQL
    BEGIN
    	RETURN CASE
	    	WHEN r = 100 THEN 5
	    	WHEN r >= 51 THEN 4 
	    	WHEN r >= 21 THEN 3
	    	WHEN r >= 1 THEN 2 
	    	ELSE 1
  	END;
END//
DELIMITER ;



-- краткое представление: справка по кредитам
CREATE VIEW light_loans_view AS 
SELECT 
	clients.name 'Заемщик',
	clients.inn 'ИНН заемщика',
	contracts.`date` 'Дата выдачи кредита',
	contracts.date_end 'Дата окончания кредита',
	GetCategory(k.quality) 'Категория качества',
	IF(a.acc_val IS NULL, 0, a.acc_val) + 
	IF(c.acc_val IS NULL, 0, c.acc_val) + 
	IF(e.acc_val IS NULL, 0, e.acc_val) + 
	IF(g.acc_val IS NULL, 0, g.acc_val) 'Общий долг',
	IF(b.acc_val IS NULL, 0, b.acc_val) + 
	IF(d.acc_val IS NULL, 0, d.acc_val) + 
	IF(f.acc_val IS NULL, 0, f.acc_val) + 
	IF(h.acc_val IS NULL, 0, h.acc_val) 'Общий резерв',
	IF(k.take_coverage = 1, i.acc_val, 0) 'Обеспечение'
FROM loans l
LEFT JOIN accounts a 
	ON l.current_debt_id = a.id
LEFT JOIN accounts b
	ON l.current_debt_reserve_id = b.id
LEFT JOIN accounts c
	ON l.overdue_debt_id = c.id
LEFT JOIN accounts d
	ON l.overdue_debt_reserve_id = d.id
LEFT JOIN accounts e 
	ON l.current_percent_id = e.id
LEFT JOIN accounts f
	ON l.current_percent_reserve_id = f.id
LEFT JOIN accounts g 
	ON l.overdue_percent_id = g.id
LEFT JOIN accounts h
	ON l.overdue_percent_reserve_id = h.id
LEFT JOIN accounts i
	ON l.coverage_id = i.id
LEFT JOIN reports k
	ON l.report_id = k.id
LEFT JOIN contracts
	ON l.contract_id = contracts.id
LEFT JOIN clients
	ON contracts.client_id = clients.id;

SELECT * FROM light_loans_view LIMIT 15;
-- вывод:
-- |Заемщик                    |ИНН заемщика|Дата выдачи кредита|Дата окончания кредита|Категория качества|Общий долг|Общий резерв |Обеспечение|
-- |---------------------------|------------|-------------------|----------------------|------------------|----------|-------------|-----------|
-- |ООО " LG пеццолайо "       |7737465684  |2021-09-20         |2009-07-20            |2                 |204044    |3203         |0          |
-- |ПАО " анкистрон навигатор "|7745959419  |2014-12-20         |2025-10-20            |5                 |1595098   |1595098      |0          |
-- |ООО " автокухня судомойка "|7734433045  |2002-10-20         |2025-09-20            |2                 |808972    |808972       |200000     |
-- |АО " азиатчина повечерие " |7732205524  |2011-07-20         |2005-07-20            |4                 |484281    |484281       |300000     |
-- |АО " азиатчина повечерие " |7732205524  |2027-10-20         |2016-10-20            |2                 |1503778   |1503778      |2880000    |
-- |АО " азиатчина повечерие " |7732205524  |2021-08-20         |2017-08-20            |5                 |3650775   |3650775      |3135600    |
-- |ООО " адипометр массажист "|7756568650  |2020-12-20         |2018-12-20            |2                 |3172951   |3172951      |0          |
-- |АО " азоогения ландкарта " |7799769465  |2004-09-20         |2021-08-20            |2                 |82784     |82784        |0          |
-- |ООО " аллилиден полиплекс "|7722165617  |2008-10-20         |2030-09-20            |2                 |744813    |744813       |666500     |
-- |ООО " альстонит пирозамок "|7728880836  |2028-07-20         |2012-07-20            |2                 |1434777   |1434777      |815000     |
-- |ООО " авиатариф фрюктидор "|7739896081  |2025-05-20         |2008-05-20            |3                 |1022003   |1022003      |1968500    |
-- |ООО " авиатариф фрюктидор "|7739896081  |2025-10-20         |2024-10-20            |2                 |135825    |135825       |775000     |
-- |АО " аккордион пуходерка " |7720928889  |2023-08-20         |2014-08-20            |2                 |756101    |396727       |350000     |
-- |ПАО " анкарамит цинерария "|7765119133  |2001-03-20         |2025-02-20            |3                 |199908    |199908       |200000     |
-- |ООО " алкандиол разломщик "|7748459253  |2007-06-20         |2006-06-20            |2                 |96825     |96825        |0          |



-- Самый загруженный аналитик (пример вложенного запроса)
SELECT 
	(SELECT CONCAT(name, ' ', surname) FROM workers w WHERE w.id = worker_id) 'Имя сотрудника', 
	(SELECT w.grade FROM workers w WHERE w.id = worker_id) 'Должность сотрудника',
	(SELECT 
		(SELECT d.department_name FROM departments d WHERE d.id = w.branch_id)
		FROM workers w WHERE w.id = worker_id) 'Департамент сотрудника',
	COUNT(*) 'Число отчетов' 
FROM reports r 
GROUP BY worker_id 
ORDER BY COUNT(*) DESC LIMIT 1;
-- Вывод:
-- |Имя сотрудника |Должность сотрудника |Департамент сотрудника |Число отчетов |
-- |---------------|---------------------|-----------------------|--------------|
-- |кирюха damien  |ведущий экономист    |Кредитный отдел        |8             |



-- Запрос на список проблемных заемщиков (пример вложенного запроса и JOINa)
SELECT 
	(SELECT cl.name FROM contracts c JOIN clients cl ON c.client_id = cl.id AND l.contract_id = c.id) 'Проблемный заемщик',
	GetCategory(r.quality) "Категория качества"
FROM loans l 
	JOIN reports r 
		ON l.report_id = r.id AND GetCategory(r.quality) >= 3
ORDER BY GetCategory(r.quality) DESC
LIMIT 5;
-- вывод:
-- |Проблемный заемщик          |Категория качества|
-- |----------------------------|------------------|
-- |ПАО " анкистрон навигатор " |5                 |
-- |ООО " альстонит тимандрей " |5                 |
-- |АО " азиатчина повечерие "  |5                 |
-- |ПАО " альфатрон рицотомия " |5                 |
-- |ПАО " анагормон нечистота " |5                 |



-- запрос на сводную аналитику по кредитам через оконные функции
SELECT * FROM light_loans_view;
SELECT 
	DISTINCT GetCategory(k.quality) 'Категория качества',
	COUNT(clients.inn) OVER w 'Количество заемщиков',
	SUM(IF(a.acc_val IS NULL, 0, a.acc_val) + 
	IF(c.acc_val IS NULL, 0, c.acc_val) + 
	IF(e.acc_val IS NULL, 0, e.acc_val) + 
	IF(g.acc_val IS NULL, 0, g.acc_val)) OVER w 'Общий долг',
	SUM(IF(b.acc_val IS NULL, 0, b.acc_val) + 
	IF(d.acc_val IS NULL, 0, d.acc_val) + 
	IF(f.acc_val IS NULL, 0, f.acc_val) + 
	IF(h.acc_val IS NULL, 0, h.acc_val)) OVER w 'Общий резерв',
	SUM(IF(k.take_coverage = 1, i.acc_val, 0)) OVER w 'Всего обеспечения',
	SUM(
		IF(
			IF(k.take_coverage = 1, i.acc_val, 0) > 0, -- если есть обеспечение
			IF(a.acc_val IS NULL, 0, a.acc_val) + IF(c.acc_val IS NULL, 0, c.acc_val) + IF(e.acc_val IS NULL, 0, e.acc_val) + IF(g.acc_val IS NULL, 0, g.acc_val), -- берем сумму долга
			0) -- иначе не берем ничего
		) OVER w 'Кредиты с обеспечением'
FROM loans l
	LEFT JOIN accounts a 
		ON l.current_debt_id = a.id
	LEFT JOIN accounts b
		ON l.current_debt_reserve_id = b.id
	LEFT JOIN accounts c
		ON l.overdue_debt_id = c.id
	LEFT JOIN accounts d
		ON l.overdue_debt_reserve_id = d.id
	LEFT JOIN accounts e 
		ON l.current_percent_id = e.id
	LEFT JOIN accounts f
		ON l.current_percent_reserve_id = f.id
	LEFT JOIN accounts g 
		ON l.overdue_percent_id = g.id
	LEFT JOIN accounts h
		ON l.overdue_percent_reserve_id = h.id
	LEFT JOIN accounts i
		ON l.coverage_id = i.id
	LEFT JOIN reports k
		ON l.report_id = k.id
	LEFT JOIN contracts
		ON l.contract_id = contracts.id
	LEFT JOIN clients
		ON contracts.client_id = clients.id
WINDOW w AS (PARTITION BY GetCategory(k.quality))
ORDER BY GetCategory(k.quality);

-- вывод:
-- |Категория качества|Количество заемщиков |Общий долг |Общий резерв |Всего обеспечения |Кредиты с обеспечением |
-- |------------------|---------------------|-----------|-------------|------------------|-----------------------|
-- |1                 |8                    |42627485   |733055       |130584100         |41825184               |
-- |2                 |120                  |779344760  |60935227     |1310416488        |610877917              |
-- |3                 |17                   |66309647   |3487519      |116016500         |49081234               |
-- |4                 |6                    |7440295    |645411       |9770500           |6524182                |
-- |5                 |31                   |179492758  |50380896     |90459165          |79800387               |



-- Триггер, который позволит по проводке разносить данные по таблице accounts
DELIMITER //
CREATE TRIGGER acc_fill BEFORE INSERT ON transactions
	FOR EACH ROW
	BEGIN
		IF ((SELECT EXISTS(SELECT * FROM accounts a WHERE a.id = NEW.acc_debet)) + (SELECT EXISTS(SELECT * FROM accounts a WHERE a.id = NEW.acc_credit)) ) < 2 -- проверка на наличие счетов
			THEN -- если счета нет - выполнение триггера и самой операции прервется и выскочит ошибка
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Прежде чем работать со счетом в проводке, его сначала требуется создать!';
		END IF;
		IF (SELECT acc_type FROM accounts_info WHERE acc_id = NEW.acc_debet) = 1 -- проверка является ли  счет по дебету активным
			THEN -- увеличиваем остаток по дебету (счет активный)
				UPDATE accounts SET acc_val = acc_val + NEW.val WHERE id = NEW.acc_debet;
			ELSE -- иначе уменьшаем остаток по дебету (счет пассивный)
				UPDATE accounts SET acc_val = acc_val - NEW.val WHERE id = NEW.acc_debet; 
		END IF;
		IF (SELECT acc_type FROM accounts_info WHERE acc_id = NEW.acc_credit) = 1 -- проверка является ли  счет по кредиту активным
			THEN -- уменьшаем остаток по кредиту (счет активный)
				UPDATE accounts SET acc_val = acc_val - NEW.val WHERE id = NEW.acc_credit;
			ELSE -- иначе увеличиваем остаток по кредиту (счет пассивный)
				UPDATE accounts SET acc_val = acc_val + NEW.val WHERE id = NEW.acc_credit;
		END IF;
	END//
DELIMITER ;



-- Процедура: проведение проводки, запускающей триггер acc_fill.
-- Процедура принимает в себя: лицевой счет по дебету, лицевой счет по кредиту, сумму проводки, содержание операции, id бухгалтера
DELIMITER //
CREATE PROCEDURE AccEntry (IN dt BIGINT UNSIGNED, IN kt BIGINT UNSIGNED, IN v BIGINT UNSIGNED, IN des VARCHAR(255), IN buh_id SMALLINT UNSIGNED)
    BEGIN
		INSERT INTO transactions (acc_debet, acc_credit, val) VALUES (dt, kt, v);
		-- выставляем дополнительную информацию в автоматическом режиме (остальное делает клиентское ПО)
		INSERT INTO transactions_info (transaction_id, created_at, description, worker_id) SELECT COUNT(*), NOW(), des, buh_id FROM transactions;
  	END//
DELIMITER ;

-- Для ускорения фильтрации по лицевым 20-значным счетам созданим INDEX по полю acc_num таблицы accounts
-- Проведение проводок - очень частая операция. Потребуется скорость выполнения.
CREATE INDEX accounts_acc_num_idx ON accounts (acc_num);



-- тест процедуры AccEntry и триггера acc_fill. Заемщик ПАО " Aльфатрон тератоген " (client_id = 16) вышел на просрочку

-- узнаем счета текущего и просроченного долга
SELECT client_id, current_debt_id, overdue_debt_id FROM loans l JOIN contracts c ON l.contract_id = c.id AND c.client_id = 16;
-- Вывод:
-- |client_id           |current_debt_id     |overdue_debt_id     |
-- |--------------------|--------------------|--------------------|
-- |16                  |407                 |446                 |

-- узнаем остатки на счетах
SELECT id, acc_num, acc_val FROM accounts WHERE id = 407 OR id = 446;
-- Вывод:
-- |id                  |acc_num              |acc_val             |
-- |--------------------|---------------------|--------------------|
-- |407                 |45207810500130000012 |195000              |
-- |446                 |45812810600130000006 |45000               |

-- Проверяем работу процедуры и триггера: списываем весь текущий долг на просроченный долг
CALL AccEntry   (
				(SELECT id FROM accounts WHERE acc_num = '45812810600130000006'), -- получаем id лицевого 20-значного счета по Дт
				(SELECT id FROM accounts WHERE acc_num = '45207810500130000012'), -- получаем id лицевого 20-значного счета по Кт
				195000, 
				'Вынесение на просрочку', 
				55
				);

SELECT id, acc_num, acc_val FROM accounts WHERE id = 407 OR id = 446;
-- Вывод:  (в таблице accounts остатки с текущего долга перенеслись на просроченный)
-- |id                  |acc_num              |acc_val             |
-- |--------------------|---------------------|--------------------|
-- |407                 |45207810500130000012 |0                   |
-- |446                 |45812810600130000006 |240000              |

SELECT acc_debet "Дт", acc_credit "Кт", val "Сумма", description "Содержание проводки", (SELECT CONCAT(name, ' ', surname) FROM workers WHERE id = worker_id) "Ответствтенный" FROM transactions t JOIN transactions_info ti ON t.id = ti.transaction_id ORDER BY t.id DESC LIMIT 1;
-- вывод:  (сформировована проводка)
-- |Дт                  |Кт                  |Сумма               |Содержание проводки     |Ответствтенный    |
-- |--------------------|--------------------|--------------------|------------------------|------------------|
-- |446                 |407                 |195000              |Вынесение на просрочку  |милена anneke     |
