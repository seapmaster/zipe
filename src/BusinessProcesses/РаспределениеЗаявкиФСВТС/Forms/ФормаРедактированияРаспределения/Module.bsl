
/////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Функция ПолучитьМассив(Таблица, ИмяКолонки)
	ВременнаяТаблица = Таблица.Скопировать();
	ВременнаяТаблица.Свернуть(ИмяКолонки);
	Возврат ВременнаяТаблица.ВыгрузитьКолонку(ИмяКолонки);
КонецФункции // ПолучитьМассив

&НаСервере
Процедура СоздатьДокументы(ТаблицаОбработки)
	НачатьТранзакцию();
	Попытка
		Для Каждого Организация Из ПолучитьМассив(ТаблицаОбработки, "Организация") Цикл
			Документ 				= Документы.РаспределениеЗаявки.СоздатьДокумент();
			Документ.Дата 			= ТекущаяДата();
			Документ.Исполнитель 	= Организация;
			Документ.Заявка 		= Объект.Предмет;
			Документ.ПредметыСнабжения.Загрузить(ТаблицаОбработки.Скопировать(Новый Структура("Организация", Организация)));
			Для Каждого Строка Из Документ.ПредметыСнабжения Цикл
				Строка.Количество 	= -1 * Строка.Количество;
			КонецЦикла; // Для Каждого Строка Из Документ.ПредметыСнабжения Цикл			
			Документ.Записать(РежимЗаписиДокумента.Проведение);
		КонецЦикла; // Для Каждого Организация Из ПолучитьМассив(ТаблицаОбработки, "Организация") Цикл
		
		Для Каждого Организация Из ПолучитьМассив(ТаблицаОбработки, "ОрганизацияНовая") Цикл
			Документ 				= Документы.РаспределениеЗаявки.СоздатьДокумент();
			Документ.Дата 			= ТекущаяДата();
			Документ.Исполнитель 	= Организация;
			Документ.Заявка 		= Объект.Предмет;
			Документ.ПредметыСнабжения.Загрузить(ТаблицаОбработки.Скопировать(Новый Структура("ОрганизацияНовая", Организация)));
			Документ.Записать(РежимЗаписиДокумента.Проведение);
		КонецЦикла; // Для Каждого Организация Из ПолучитьМассив(ТаблицаОбработки, "Организация") Цикл
		
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось изменить распределение: " + ОписаниеОшибки());
	КонецПопытки;
	
	
КонецПроцедуры // СоздатьДокументы

&НаСервере
Функция ПодготовитьТаблицуОбработки()
	Результат = Новый ТаблицаЗначений;
	Результат.Колонки.Добавить("ПредметСнабжения");
	Результат.Колонки.Добавить("Количество");
	Результат.Колонки.Добавить("Организация");
	Результат.Колонки.Добавить("ОрганизацияНовая");
	Возврат Результат;
КонецФункции // ПодготовитьТаблицуОбработки

&НаСервере
Процедура ВыполнитьЗаменуОрганизации(Организация, ИзменяемыеСтроки = Неопределено)
	Запрос 				= Новый Запрос;
	Запрос.Текст 		= ТаблицаРаспределения.ТекстЗапроса;
	Запрос.УстановитьПараметр("Заявка", Объект.Предмет);
	ТаблицаДанных 		= Запрос.Выполнить().Выгрузить();
	ТаблицаОбработки	= ПодготовитьТаблицуОбработки();
	// Соберем таблицу для обработки
	Для Каждого Строка Из ТаблицаДанных Цикл
		Если Строка.Организация = Организация Тогда
			Продолжить;
		КонецЕсли; // Если Строка.Органиазация = Организация Тогда
		
		Если Не ИзменяемыеСтроки = Неопределено 
			И ИзменяемыеСтроки.Найти(Строка.НомерСтроки) = Неопределено Тогда
			Продолжить;
		КонецЕсли; // Если Не ИзменяемыеСтроки = Неопределено Тогда		
		
		НоваяСтрока 					= ТаблицаОбработки.Добавить();
		НоваяСтрока.ПредметСнабжения 	= Строка.ПредметСнабжения;
		НоваяСтрока.Количество 			= Строка.Количество;
		НоваяСтрока.Организация 		= Строка.Организация;
		НоваяСтрока.ОрганизацияНовая 	= Организация;
	КонецЦикла; // Для Каждого Строка Из ТаблицаДанных Цикл
	
	// Создадим документы
	Если ТаблицаОбработки.Количество() > 0 Тогда
		СоздатьДокументы(ТаблицаОбработки);
	КонецЕсли; // Если ТаблицаОбработки.Количество() > 0 Тогда
	
КонецПроцедуры // ВыполнитьЗаменуОрганизации

&НаКлиенте
Процедура ПослеПодтвержденияОрганизации(Результат, ДополнительныеПараметры) Экспорт
	Если Не Результат = КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли; // Если Не Результат = КодВозвратаДиалога.ОК Тогда
	
	Если Не ДополнительныеПараметры.Свойство("Организация") Тогда
		Возврат;
	КонецЕсли; // Если Не ДополнительныеПараметры.Свойство("Организация") Тогда
	
	Если ДополнительныеПараметры.Свойство("ВыделенныеСтроки") Тогда
		ИзменяемыеСтроки = Новый Массив;
		Для Каждого Идентификатор Из ДополнительныеПараметры.ВыделенныеСтроки Цикл
			Строка = Элементы.ТаблицаРаспределения.ДанныеСтроки(Идентификатор);
			Если Не Строка = Неопределено Тогда
				ИзменяемыеСтроки.Добавить(Строка.НомерСтроки);
			КонецЕсли; // Если Не Строка = Неопределено Тогда			
		КонецЦикла; // Для Каждого Идентификатор Из ДополнительныеПараметры.ВыделенныеСтроки Цикл		
		ВыполнитьЗаменуОрганизации(Организация, ИзменяемыеСтроки);
	Иначе
		ВыполнитьЗаменуОрганизации(Организация);
	КонецЕсли; // Если ДополнительныеПараметры.Свойство("ВыделенныеСтроки") Тогда
	Элементы.ТаблицаРаспределения.Обновить();
КонецПроцедуры // ПослеПодтвержденияОрганизации

/////////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

&НаКлиенте
Процедура КомандаПоказатьВложения(Команда)
	ПараметрыФормы 	= Новый Структура;
	ПараметрыФормы.Вставить("ВладелецФайла", 	Объект.Предмет);	
	ПараметрыФормы.Вставить("ТолькоПросмотр", 	Истина);	
	ОткрытьФорму("ОбщаяФорма.ПрисоединенныеФайлы", ПараметрыФормы, ЭтаФорма);
КонецПроцедуры // КомандаПоказатьВложения

&НаКлиенте
Процедура КомандаУстановитьДляВсех(Команда)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнена организация!",,,"Организация");
		Возврат;
	КонецЕсли; // Если Не ЗначениеЗаполнено(Организация) Тогда
	
	ДополнительныеПараметры = Новый Структура("Организация", Организация);
	ОписаниеОповещения 		= Новый ОписаниеОповещения("ПослеПодтвержденияОрганизации", ЭтаФорма, ДополнительныеПараметры);
	ПоказатьВопрос(ОписаниеОповещения, 
					"Установить выбранную организацию для всех строк?",
					РежимДиалогаВопрос.ОКОтмена,
					30, 
					КодВозвратаДиалога.Отмена, 
					"Внимание", 
					КодВозвратаДиалога.Отмена);
КонецПроцедуры // КомандаУстановитьДляВсех

&НаКлиенте
Процедура КомандаУстановитьДляВыбранных(Команда)
	Если Не ЗначениеЗаполнено(Организация) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не заполнена организация!",,,"Организация");
		Возврат;                  
	КонецЕсли; // Если Не ЗначениеЗаполнено(Организация) Тогда
	
	ВыделенныеСтроки = Элементы.ТаблицаРаспределения.ВыделенныеСтроки;
	Если ВыделенныеСтроки.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрано ни одной строки!",,,"ТаблицаРаспределения");
		Возврат;
	КонецЕсли; // Если ВыделенныеСтроки.Количество() = 0 Тогда
	
	ДополнительныеПараметры = Новый Структура("Организация, ВыделенныеСтроки", Организация, ВыделенныеСтроки);
	ОписаниеОповещения 		= Новый ОписаниеОповещения("ПослеПодтвержденияОрганизации", ЭтаФорма, ДополнительныеПараметры);
	ПоказатьВопрос(ОписаниеОповещения, 
					"Установить выбранную организацию для выбранных строк?",
					РежимДиалогаВопрос.ОКОтмена,
					30, 
					КодВозвратаДиалога.Отмена, 
					"Внимание", 
					КодВозвратаДиалога.Отмена);
КонецПроцедуры // КомандаУстановитьДляВыбранных

/////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ИсторияСогласования 						= Документы.ЗаявкаФСВТС.СформироватьТабличныйДокументИсторииСогласования(Объект.БизнесПроцесс);
	Элементы.КомандаПоказатьВложения.Заголовок 	= Справочники.ЗаявкаФСВТСПрисоединенныеФайлы.ПолучитьКоличество(Объект.Предмет);
	ТаблицаРаспределения.Параметры.УстановитьЗначениеПараметра("Заявка", Объект.Предмет);
КонецПроцедуры // ПриСозданииНаСервере