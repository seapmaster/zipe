#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// СтандартныеПодсистемы.УправлениеДоступом

// Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) создается прикладным разработчиком
//  в модулях объектов, тип которых задан в одной из подписок на событие.
//  ЗаписатьНаборыЗначенийДоступа или ЗаписатьЗависимыеНаборыЗначенийДоступа.
//  В процедуре выполняется заполнение наборов значений доступа по свойствам объекта.
//  
// Параметры:
//  Таблица - ТаблицаЗначений - возвращаемая функцией ТаблицаНаборыЗначенийДоступа.
//
Процедура ЗаполнитьНаборыЗначенийДоступа(Таблица) Экспорт
	
	// Логика ограничения для
	// - чтения:    Автор ИЛИ Исполнитель (с учетом адресации) ИЛИ Проверяющий (с учетом адресации)
	// - изменения: Автор.
	
	// Если предмет не задан (т.е. бизнес-процесс без основания),
	// тогда предмет не участвует в логике ограничения.
	
	// Чтение, Изменение: набор № 1.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 1;
	Строка.Чтение          = Истина;
	Строка.Изменение       = Истина;
	Строка.ЗначениеДоступа = Автор;
	
	// Чтение: набор № 2.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 2;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = ГруппаИсполнителейЗадач;
	
	// Чтение: набор № 3.
	Строка = Таблица.Добавить();
	Строка.НомерНабора     = 3;
	Строка.Чтение          = Истина;
	Строка.ЗначениеДоступа = ГруппаИсполнителейЗадачПроверяющий;

КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// Актуализирует значения реквизит невыполненных задач 
// согласно реквизитам бизнес-процесса Задание:
//   Важность, СрокИсполнения, Наименование и Автор.
//
Процедура ИзменитьРеквизитыНевыполненныхЗадач() Экспорт

	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Ссылка);
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос( 
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс
			|	И Задачи.ПометкаУдаления = ЛОЖЬ
			|	И Задачи.Выполнена = ЛОЖЬ");
		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Важность = Важность;
			ЗадачаОбъект.СрокИсполнения = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				СрокИсполненияЗадачиДляВыполнения(), СрокИсполненияЗадачиДляПроверки());
			ЗадачаОбъект.Наименование = 
				?(ЗадачаОбъект.ТочкаМаршрута = БизнесПроцессы.Задание.ТочкиМаршрута.Выполнить, 
				НаименованиеЗадачиДляВыполнения(), НаименованиеЗадачиДляПроверки());
			ЗадачаОбъект.Автор = Автор;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// Это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

#КонецОбласти

#Область ОбработчикиСобытий

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий бизнес-процесса.

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Автор <> Неопределено И Не Автор.Пустая() Тогда
		АвторСтрокой = Строка(Автор);
	КонецЕсли;
	
	БизнесПроцессыИЗадачиСервер.ПроверитьПраваНаИзменениеСостоянияБизнесПроцесса(ЭтотОбъект);
	
	Если ЗначениеЗаполнено(ГлавнаяЗадача) 
		И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(ГлавнаяЗадача, "БизнесПроцесс") = ЭтотОбъект.Ссылка Тогда
		
		ВызватьИсключение НСтр("ru = 'Собственная задача бизнес-процесса не может быть указана как главная задача.'");
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	ГруппаИсполнителейЗадач = ?(ТипЗнч(Исполнитель) = Тип("СправочникСсылка.РолиИсполнителей"), 
		БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(Исполнитель, ОсновнойОбъектАдресации, ДополнительныйОбъектАдресации), 
		Исполнитель);
	ГруппаИсполнителейЗадачПроверяющий = ?(ТипЗнч(Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей"), 
		БизнесПроцессыИЗадачиСервер.ГруппаИсполнителейЗадач(Проверяющий, ОсновнойОбъектАдресацииПроверяющий, ДополнительныйОбъектАдресацииПроверяющий), 
		Проверяющий);
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() И ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, "Предмет") <> Предмет Тогда
		ИзменитьПредметЗадач();	
	КонецЕсли;
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если ЭтоНовый() Тогда
		Автор = Пользователи.АвторизованныйПользователь();
		Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		НаПроверке = Истина;
		Проверяющий = Пользователи.АвторизованныйПользователь();
		Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
		Если ТипЗнч(ДанныеЗаполнения) = Тип("СправочникСсылка.Пользователи") Тогда
			Исполнитель = ДанныеЗаполнения;
		Иначе
			// Для возможности автоподбора в незаполненном поле Исполнитель.
			Исполнитель = Справочники.Пользователи.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;
	
	Если ДанныеЗаполнения <> Неопределено И ТипЗнч(ДанныеЗаполнения) <> Тип("Структура") 
		И ДанныеЗаполнения <> Задачи.ЗадачаИсполнителя.ПустаяСсылка() Тогда
		
		Если ТипЗнч(ДанныеЗаполнения) <> Тип("ЗадачаСсылка.ЗадачаИсполнителя") Тогда
			Предмет = ДанныеЗаполнения;
		Иначе
			Предмет = ДанныеЗаполнения.Предмет;
		КонецЕсли;
		
	КонецЕсли;	
	
	БизнесПроцессыИЗадачиСервер.ЗаполнитьГлавнуюЗадачу(ЭтотОбъект, ДанныеЗаполнения);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	МассивНепроверяемыхРеквизитов = Новый Массив();
	Если Не НаПроверке Тогда
		МассивНепроверяемыхРеквизитов.Добавить("Проверяющий");
	КонецЕсли;
	ОбщегоНазначения.УдалитьНепроверяемыеРеквизитыИзМассива(ПроверяемыеРеквизиты, МассивНепроверяемыхРеквизитов);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерИтерации = 0;
	Выполнено = Ложь;
	Подтверждено = Ложь;
	РезультатВыполнения = "";
	ДатаЗавершения = '00010101000000';
	Состояние = Перечисления.СостоянияБизнесПроцессов.Активен;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики событий элементов карты маршрута.

Процедура ВыполнитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	НомерИтерации = НомерИтерации + 1;
	Записать();
	
	ТочкиМаршрута = БизнесПроцессы.КорректировкаСправочников.ТочкиМаршрута;
	КартаБП = ПолучитьКартуМаршрута().ЭлементыГрафическойСхемы;
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи.
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		Задача.АвторСтрокой = Строка(Автор);
		
		Если ЗначениеЗаполнено(ТочкаМаршрутаБизнесПроцесса.РольИсполнителя) Тогда
			
			Задача.РольИсполнителя = ТочкаМаршрутаБизнесПроцесса.РольИсполнителя;
			Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресации;
			Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресации;
			Задача.Исполнитель = Неопределено;
			
		ИначеЕсли ТочкаМаршрутаБизнесПроцесса = ТочкиМаршрута.ВнестиИзменения 
			Или ТочкаМаршрутаБизнесПроцесса = ТочкиМаршрута.ОповещениеОбОтклонении Тогда
			
			Задача.Исполнитель = Автор;
			
		Иначе
			
			Задача.Исполнитель = ТочкаМаршрутаБизнесПроцесса.Исполнитель;
			
		КонецЕсли;
		
		
		
		Задача.Наименование = ТочкаМаршрутаБизнесПроцесса.НаименованиеЗадачи + " " + Предмет.Метаданные().Синоним +
			"(" + ?(ЗначениеЗаполнено(Предмет), "редактирование ", "создание ") + "элемента)";//НаименованиеЗадачиДляВыполнения();
		Задача.СрокИсполнения = СрокИсполненияЗадачиДляВыполнения();
		Задача.Важность = Важность;
		Задача.Предмет = Предмет;
		Задача.Описание = КартаБП[ТочкаМаршрутаБизнесПроцесса.Имя].Подсказка;//Содержание;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ВыполнитьПередСозданиемЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, СтандартнаяОбработка)
	
	Если Предмет = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
КонецПроцедуры

Процедура ВыполнитьПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)
	
	РезультатВыполнения = РезультатВыполненияТочкиВыполнить(Задача) + РезультатВыполнения;
	Записать();
	
КонецПроцедуры

Процедура ПроверитьПриСозданииЗадач(ТочкаМаршрутаБизнесПроцесса, ФормируемыеЗадачи, Отказ)
	
	Если Проверяющий.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	// Устанавливаем реквизиты адресации и доп. реквизиты для каждой задачи.
	Для каждого Задача Из ФормируемыеЗадачи Цикл
		
		Задача.Автор = Автор;
		Если ТипЗнч(Проверяющий) = Тип("СправочникСсылка.РолиИсполнителей") Тогда
			Задача.РольИсполнителя = Проверяющий;
			Задача.ОсновнойОбъектАдресации = ОсновнойОбъектАдресацииПроверяющий;
			Задача.ДополнительныйОбъектАдресации = ДополнительныйОбъектАдресацииПроверяющий;
		Иначе	
			Задача.Исполнитель = Проверяющий;
		КонецЕсли;
		
		Задача.Наименование = НаименованиеЗадачиДляПроверки();
		Задача.СрокИсполнения = СрокИсполненияЗадачиДляПроверки();
		Задача.Важность = Важность;
		Задача.Предмет = Предмет;
		
	КонецЦикла;
	
КонецПроцедуры

Процедура ПроверитьПриВыполнении(ТочкаМаршрутаБизнесПроцесса, Задача, Отказ)

	РезультатВыполнения = РезультатВыполненияТочкиПроверить(Задача) + РезультатВыполнения;
	Записать();
	
КонецПроцедуры

Процедура НужнаПроверкаПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = НаПроверке;

КонецПроцедуры

Процедура ВернутьИсполнителюПроверкаУсловия(ТочкаМаршрутаБизнесПроцесса, Результат)
	
	Результат = НЕ Подтверждено;
	
КонецПроцедуры

Процедура ЗавершениеПриЗавершении(ТочкаМаршрутаБизнесПроцесса, Отказ)
	
	ДатаЗавершения = БизнесПроцессыИЗадачиСервер.ДатаЗавершенияБизнесПроцесса(Ссылка);
	Записать();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ИзменитьПредметЗадач()

	УстановитьПривилегированныйРежим(Истина);
	НачатьТранзакцию();
	Попытка
		Блокировка = Новый БлокировкаДанных;
		ЭлементБлокировки = Блокировка.Добавить("Задача.ЗадачаИсполнителя");
		ЭлементБлокировки.УстановитьЗначение("БизнесПроцесс", Ссылка);
		Блокировка.Заблокировать();
		
		Запрос = Новый Запрос(
			"ВЫБРАТЬ
			|	Задачи.Ссылка КАК Ссылка
			|ИЗ
			|	Задача.ЗадачаИсполнителя КАК Задачи
			|ГДЕ
			|	Задачи.БизнесПроцесс = &БизнесПроцесс");

		Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
		ВыборкаДетальныеЗаписи = Запрос.Выполнить().Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			ЗадачаОбъект = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			ЗадачаОбъект.Предмет = Предмет;
			// Не выполняем предварительную блокировку данных для редактирования, т.к.
			// Это изменение имеет более высокий приоритет над открытыми формами задач.
			ЗадачаОбъект.Записать();
		КонецЦикла;
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры 

Функция НаименованиеЗадачиДляВыполнения()
	
	Возврат Наименование;	
	
КонецФункции

Функция СрокИсполненияЗадачиДляВыполнения()
	
	Возврат СрокИсполнения;	
	
КонецФункции

Функция НаименованиеЗадачиДляПроверки()
	
	Возврат БизнесПроцессы.Задание.ТочкиМаршрута.Проверить.НаименованиеЗадачи + ": " + Наименование;
	
КонецФункции

Функция СрокИсполненияЗадачиДляПроверки()
	
	Возврат СрокПроверки;	
	
КонецФункции

Функция РезультатВыполненияТочкиВыполнить(Знач ЗадачаСсылка)
	
	СтрокаФормат = ?(Выполнено,
	    НСтр("ru = '%1, %2 выполнил(а) задачу:
		           |%3
		           |'"),
		НСтр("ru = '%1, %2 отклонил(а) задачу:
		           |%3
		           |'"));
	ЗадачаДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗадачаСсылка, 
		"РезультатВыполнения,ДатаИсполнения,Исполнитель");
	Комментарий = СокрЛП(ЗадачаДанные.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаДанные.ДатаИсполнения, ЗадачаДанные.Исполнитель, Комментарий);
	Возврат Результат;
	
КонецФункции

Функция РезультатВыполненияТочкиПроверить(Знач ЗадачаСсылка)  
	
	Если НЕ Подтверждено Тогда
		СтрокаФормат = НСтр("ru = '%1, %2 вернул(а) задачу на доработку:
			|%3
			|'");
	Иначе
		СтрокаФормат = ?(Выполнено,
			НСтр("ru = '%1, %2 подтвердил(а) выполнение задачи:
			           |%3
			           |'"),
			НСтр("ru = '%1, %2 подтвердил(а) отмену задачи:
			           |%3
			           |'"));
	КонецЕсли;
	
	ЗадачаДанные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ЗадачаСсылка, 
		"РезультатВыполнения,ДатаИсполнения,Исполнитель");
	Комментарий = СокрЛП(ЗадачаДанные.РезультатВыполнения);
	Комментарий = ?(ПустаяСтрока(Комментарий), "", Комментарий + Символы.ПС);
	Результат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(СтрокаФормат, ЗадачаДанные.ДатаИсполнения, ЗадачаДанные.Исполнитель, Комментарий);
	Возврат Результат;

КонецФункции

Процедура АкцептИзмененийОбработкаВыбораВарианта(ТочкаВыбораВарианта, Результат)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ЗадачаИсполнителя.ВыбранныйВариант КАК ВыбранныйВариант
	|ИЗ
	|	Задача.ЗадачаИсполнителя КАК ЗадачаИсполнителя
	|ГДЕ
	|	ЗадачаИсполнителя.Выполнена
	|	И НЕ ЗадачаИсполнителя.ПометкаУдаления
	|	И ЗадачаИсполнителя.БизнесПроцесс = &БизнесПроцесс
	|	И ЗадачаИсполнителя.ТочкаМаршрута = &ТочкаМаршрута";
	
	Запрос.УстановитьПараметр("БизнесПроцесс", Ссылка);
	Запрос.УстановитьПараметр("ТочкаМаршрута", БизнесПроцессы.КорректировкаСправочников.ТочкиМаршрута.ЗапросНаАкцептИзменений);
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Если Выборка.Следующий() Тогда
		
		Результат = ТочкаВыбораВарианта.Варианты[Выборка.ВыбранныйВариант];
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли