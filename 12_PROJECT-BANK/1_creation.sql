CREATE DATABASE bank;
USE bank;

CREATE TABLE accounts (
	id SERIAL PRIMARY KEY,
	acc_num VARCHAR(255) COMMENT "Номер счета",
	acc_val BIGINT UNSIGNED COMMENT "Остаток на счете"
);

CREATE TABLE accounts_info (
	id SERIAL PRIMARY KEY,
	acc_id BIGINT UNSIGNED COMMENT "Связь со счетами",
	acc_name VARCHAR(255) COMMENT "Наименование счета",
	acc_type BOOL COMMENT "Счет активный*",
	client_id BIGINT UNSIGNED COMMENT "Клиент",
	filial TINYINT UNSIGNED COMMENT "Филиал",
	created_at DATETIME,
	updated_at DATETIME
);

CREATE TABLE loans (
	id SERIAL PRIMARY KEY,
	contract_id BIGINT UNSIGNED COMMENT "Договор",
	current_debt_id BIGINT UNSIGNED COMMENT "Текущий долг",
	current_debt_reserve_id BIGINT UNSIGNED COMMENT "Резерв по текущему долгу",
	overdue_debt_id BIGINT UNSIGNED COMMENT "Просроченный долг",
	overdue_debt_reserve_id BIGINT UNSIGNED COMMENT "Резерв по просроченному долгу",
	current_percent_id BIGINT UNSIGNED COMMENT "Текущие проценты",
	current_percent_reserve_id BIGINT UNSIGNED COMMENT "Резерв по текущим процентам",
	overdue_percent_id BIGINT UNSIGNED COMMENT "Просроченные проценты",
	overdue_percent_reserve_id BIGINT UNSIGNED COMMENT "Резерв по просроченным процентам",
	coverage_id BIGINT UNSIGNED COMMENT "Обеспечение",
	report_id BIGINT UNSIGNED COMMENT "Аналитика по кредиту"
);

CREATE TABLE reports (
	id SERIAL PRIMARY KEY,
	quality DECIMAL(5,2) COMMENT "Уровень расчетного резерва, %",
	analytics TEXT COMMENT "Описание заемщика и анализ кредита",
	take_coverage BOOL COMMENT "Принимается ли обеспечение",
	worker_id SMALLINT UNSIGNED COMMENT "Ответственный аналитик",
	created_at DATETIME,
	updated_at DATETIME
);

CREATE TABLE contracts (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT "Наименование договора",
	date DATE COMMENT "Дата договора",
	date_end DATE COMMENT "Срок действия договора",
	client_id BIGINT UNSIGNED COMMENT "Клиент",
	worker_id SMALLINT UNSIGNED COMMENT "Подписант со стороны банка",
	created_at DATETIME
);

-- Таблицы transactions и transactions_info будут работать на движке ARCHIEVE, не поддерживающем внешние ключи. 
-- Они представляют собой журнал проводок и допинфо по нему. 
-- Журналы формируются процедурой по созданию проводки, которая в т.ч. запускает триггер, разносящий данные по таблицам.
CREATE TABLE transactions (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	acc_debet BIGINT UNSIGNED COMMENT "Счет по дебету",
	acc_credit BIGINT UNSIGNED COMMENT "Счет по кредиту",
	val BIGINT UNSIGNED COMMENT "Сумма проводки"
) ENGINE = Archive;

CREATE TABLE transactions_info (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	transaction_id BIGINT UNSIGNED COMMENT "Связь по транзакции",
	description VARCHAR(255) COMMENT "Содержание транзакции",
	worker_id SMALLINT UNSIGNED COMMENT "Ответственный бухгалтер",
	created_at DATETIME
) ENGINE = Archive;

CREATE TABLE clients (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT "Наименование организации / имя заемщика-физ.лица",
	surname VARCHAR(255) COMMENT "Фамилия заемщика-физ.лица",
	birthday DATE COMMENT "Дата создания / рождения",
	inn VARCHAR(255) COMMENT "ИНН",
	created_at DATETIME,
	updated_at DATETIME,
	is_worker BOOL COMMENT "Является ли клиент работником банка",
	is_organization BOOL COMMENT "Является ли клиент организацией"
);

CREATE TABLE workers (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) COMMENT "Имя",
	surname VARCHAR(255) COMMENT "Фамилия",
	grade VARCHAR(255) COMMENT "Должность",
	branch_id TINYINT UNSIGNED COMMENT "Департамент"
);

CREATE TABLE departments (
	id TINYINT UNSIGNED PRIMARY KEY,
	department_name VARCHAR(255) COMMENT "Наименование"
);

ALTER TABLE accounts_info
	ADD CONSTRAINT accounts_info_accounts_acc_id_fk
	FOREIGN KEY (acc_id) REFERENCES accounts(id),
	ADD CONSTRAINT accounts_info_clients_client_id_fk
	FOREIGN KEY (client_id) REFERENCES clients(id),
	ADD CONSTRAINT accounts_info_departments_filial_fk
	FOREIGN KEY (filial) REFERENCES departments(id);

ALTER TABLE loans
	ADD CONSTRAINT loans_contracts_contract_id_fk
	FOREIGN KEY (contract_id) REFERENCES contracts(id),
	ADD CONSTRAINT loans_accounts_current_debt_id_fk
	FOREIGN KEY (current_debt_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_current_debt_reserve_id_fk
	FOREIGN KEY (current_debt_reserve_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_overdue_debt_id_fk
	FOREIGN KEY (overdue_debt_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_overdue_debt_reserve_id_fk
	FOREIGN KEY (overdue_debt_reserve_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_current_percent_id_fk
	FOREIGN KEY (current_percent_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_current_percent_reserve_id_fk
	FOREIGN KEY (current_percent_reserve_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_overdue_percent_id_fk
	FOREIGN KEY (overdue_percent_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_overdue_percent_reserve_id_fk
	FOREIGN KEY (overdue_percent_reserve_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_accounts_coverage_id_fk
	FOREIGN KEY (coverage_id) REFERENCES accounts(id),
	ADD CONSTRAINT loans_reports_report_id_fk
	FOREIGN KEY (report_id) REFERENCES reports(id);

ALTER TABLE reports
	ADD CONSTRAINT reports_workers_worker_id_fk
	FOREIGN KEY (worker_id) REFERENCES workers(id);

ALTER TABLE contracts
	ADD CONSTRAINT contracts_clients_client_id_fk
	FOREIGN KEY (client_id) REFERENCES clients(id),
	ADD CONSTRAINT contracts_workers_worker_id_fk
	FOREIGN KEY (worker_id) REFERENCES workers(id);

-- Таблицы transactions и transactions_info будут работать на движке ARCHIEVE, не поддерживающем внешние ключи. 
-- ALTER TABLE transactions
-- 	ADD CONSTRAINT transactions_accounts_acc_debet_fk
-- 	FOREIGN KEY (acc_debet) REFERENCES accounts(id),
-- 	ADD CONSTRAINT transactions_accounts_acc_credit_fk
-- 	FOREIGN KEY (acc_credit) REFERENCES accounts(id);
-- 
-- ALTER TABLE transactions_info
-- 	ADD CONSTRAINT transactions_info_transactions_transaction_id_fk
-- 	FOREIGN KEY (transaction_id) REFERENCES transactions(id),
-- 	ADD CONSTRAINT transactions_info_workers_worker_id_fk
-- 	FOREIGN KEY (worker_id) REFERENCES workers(id);

ALTER TABLE workers
	ADD CONSTRAINT workers_departments_branch_id_fk
	FOREIGN KEY (branch_id) REFERENCES departments(id);
