
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		
		Возврат;
		
	КонецЕсли;
	
	Если Параметры.Свойство("Ссылка") Тогда
		
		ЗначениеВРеквизитФормы(Параметры.Ссылка.ПолучитьОбъект(), "Объект");
		
	КонецЕсли;
	
	Параметры.Свойство("ПолноеИмяФайла", ПолноеИмяФайла);
	
	ТочкиМаршрута = БизнесПроцессы.ЗапросНаАктуализациюКаталогаПоставщика.ТочкиМаршрута;
	
	// + 04.07.2018 10:53:05 Базунов Д.А. Задача: 
	Соответствие = Новый Соответствие;
	ПроцессОбъект = ДанныеФормыВЗначение(Объект, Тип("ЗадачаОбъект.ЗадачаИсполнителя"));
	Для каждого Строка Из ПроцессОбъект.БизнесПроцесс.ПредметыСнабжения Цикл
		Если Строка.ИмяФайлаКартинки = "" Тогда
			Продолжить;
		КонецЕсли; 
		Соответствие.Вставить(Строка.Идентификатор, ПоместитьВоВременноеХранилище(Строка.ХранилищеКартинки.Получить(), Новый УникальныйИдентификатор));
	КонецЦикла;
	ЗначениеВДанныеФормы(ПроцессОбъект, Объект);
	// - 04.07.2018 10:53:05 Базунов Д.А. Задача:	
	
	ПредметыСнабжения.Загрузить(Объект.БизнесПроцесс.ПредметыСнабжения.Выгрузить());
	
	// + 03.07.2018 14:45:42 Базунов Д.А. Задача: 
	Для каждого Элем Из Соответствие Цикл
		Найд = ПредметыСнабжения.НайтиСтроки(Новый Структура("Идентификатор", Элем.Ключ));
		Найд[0].ХранилищеКартинкиВременное = Элем.Значение;
	КонецЦикла; 
	// - 03.07.2018 14:45:42 Базунов Д.А. Задача:
	
	Характеристики.Загрузить(Объект.БизнесПроцесс.Характеристики.Выгрузить());
	Аналоги.Загрузить(Объект.БизнесПроцесс.Аналоги.Выгрузить());
	
	// Для нового объекта выполняем код инициализации формы в ПриСозданииНаСервере.
	// Для существующего - в ПриЧтенииНаСервере.
	Если Объект.Ссылка.Пустая() Тогда
		
		ИнициализацияФормы();
		
	КонецЕсли;
	
	УстановитьПривилегированныйРежим(Истина);
	АвторСтрокой = Строка(Объект.Автор);
	
	Элементы.ЗагрузитьИзФайла.Видимость = (Объект.ТочкаМаршрута = ТочкиМаршрута.ОжиданиеПолученияОтвета);	
	
	Если Объект.ТочкаМаршрута = ТочкиМаршрута.ОбновлениеДанныхВКаталогеПС Тогда
		
		Элементы.ГруппаРезультатОбщая.Видимость = Ложь;
		Элементы.ПредметыСнабжения.ТолькоПросмотр = Истина;
		Элементы.Характеристики.ТолькоПросмотр = Истина;
		Элементы.Аналоги.ТолькоПросмотр = Истина;
	
	ИначеЕсли Объект.ТочкаМаршрута = ТочкиМаршрута.ОжиданиеПолученияОтвета Тогда
		
		Элементы.Выполнена.Заголовок = "Отправить на согласование";
		
	ИначеЕсли Объект.ТочкаМаршрута = ТочкиМаршрута.СогласованиеИзменений Тогда
		
		Элементы.Выполнена.Заголовок = "Согласовать";
		Элементы.ПредметыСнабженияСогласовано.Видимость = Истина;
		Элементы.ПредметыСнабженияСогласовано.Доступность = Истина;
		Элементы.ПредметыСнабженияУстановитьВсе.Видимость = Истина;
		Элементы.ПредметыСнабженияСнятьВсе.Видимость = Истина;
		
	Иначе
		
		Элементы.Выполнена.Заголовок = "Принять";
		Элементы.Отклонить.Видимость = Ложь;
		
		Если Объект.ТочкаМаршрута = ТочкиМаршрута.ПринятиеИзменений Тогда
			
			Элементы.ПредметыСнабженияСогласовано.Видимость = Истина;
			
		КонецЕсли;
		
	КонецЕсли;
	
	Если Объект.ТочкаМаршрута = ТочкиМаршрута.ПринятиеИзменений Тогда
		
		ЕстьНесогласованные = (ПредметыСнабжения.НайтиСтроки(Новый Структура("Согласовано", Ложь)).Количество() > 0);
		Элементы.ПринятьИОтправить.Видимость = ЕстьНесогласованные;
		
	КонецЕсли;
	
	КорректировкаДанныхСправочников.УстановитьУсловноеОформление(ЭтаФорма, Ложь);
	
	ОтображатьХарактеристикиПредметаСнабжения = Истина;
	
	СравнитьСДаннымиБД();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
		
		РезультатЗагрузки = КорректировкаДанныхСправочниковКлиент.ВыполнитьЗагрузкуФайлаОтПоставщика(ЭтаФорма, Ложь, ПолноеИмяФайла);
		
		Если ЗначениеЗаполнено(РезультатЗагрузки) Тогда
			
			АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(РезультатЗагрузки));
			
			ДобавитьФайлВПрисоединенныеФайлы(РезультатЗагрузки, АдресВоВременномХранилище);
			
		КонецЕсли;
		
	КонецЕсли;
	
	ЗаполнитьХарактеристикиПредметаСнабжения();
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ИнициализацияФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	БизнесПроцессыИЗадачиКлиент.ФормаЗадачиОбработкаОповещения(ЭтотОбъект, ИмяСобытия, Параметр, Источник);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДекорацияОткрытьФормуЗадачиНажатие(Элемент)
	
	ПоказатьЗначение(,Объект.Ссылка);
	Модифицированность = Ложь;
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметНажатие(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПоказатьЗначение(,Объект.Предмет);
	
КонецПроцедуры

&НаКлиенте
Процедура ДатаИсполненияПриИзменении(Элемент)
	
	Если Объект.ДатаИсполнения = НачалоДня(Объект.ДатаИсполнения) Тогда
		Объект.ДатаИсполнения = КонецДня(Объект.ДатаИсполнения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрытьВыполнить(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция ЭтоТочкаМарштрутаОжиданиеПолученияОтвета()
	
	Возврат Объект.ТочкаМаршрута = БизнесПроцессы.ВзаимодействиеСРОЭ.ТочкиМаршрута.ОжиданиеПолученияОтвета;
	
КонецФункции

&НаКлиенте
Процедура ВыполненаВыполнить(Команда)
	
	// + 04.07.2018 12:04:05 Базунов Д.А. Задача: 
	// При записи на сервере есть, дубль !!!
	//Если Не ЗафиксироватьПолученныеДанные() Тогда
	//	
	//	Возврат;
	//	
	//КонецЕсли;
	// - 04.07.2018 12:04:05 Базунов Д.А. Задача:

	Объект.ВыбранныйВариант = ПолучитьЗаголовокКнопкиВыполнена(Объект.ТочкаМаршрута);

	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);

КонецПроцедуры

&НаКлиенте
Процедура ПринятьИОтправить(Команда)
	
	Если Не ЗафиксироватьПолученныеДанные() Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Объект.ВыбранныйВариант = "ПринятоИОтправлено";
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьЗаголовокКнопкиВыполнена(ТочкаМаршрута)
	
	ТочкиМаршрута = БизнесПроцессы.ЗапросНаАктуализациюКаталогаПоставщика.ТочкиМаршрута;
	
	Если ТочкаМаршрута = ТочкиМаршрута.ОжиданиеПолученияОтвета Тогда
		
		Результат = "ДанныеПолучены";
		
	ИначеЕсли ТочкаМаршрута = ТочкиМаршрута.СогласованиеИзменений Тогда
		
		Результат = "Согласовано";
		
	ИначеЕсли ТочкаМаршрута = ТочкиМаршрута.ПринятиеИзменений Тогда
		
		Результат = "Принято";
		
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

&НаСервере
Функция ЗафиксироватьПолученныеДанные()
	
	БизнесПроцессОбъект = Объект.БизнесПроцесс.ПолучитьОбъект();
	
	ТаблицаПС = ПредметыСнабжения.Выгрузить();
	
	БизнесПроцессОбъект.ПредметыСнабжения.Загрузить(ТаблицаПС);
	
	// + 03.07.2018 13:50:38 Базунов Д.А. Задача: 
	// Пишем файлы из временного хранилища в реквизит ТЧ
	ТабличнаяЧастьБП = БизнесПроцессОбъект.ПредметыСнабжения;
	
	МассивАдресовДляУдаления = Новый Массив;
	
	Для каждого Стр Из ТаблицаПС Цикл
		
		Если Стр.ХранилищеКартинкиВременное = "" Тогда
			Продолжить;
		КонецЕсли; 
		
		Найд = ТабличнаяЧастьБП.Найти(Стр.Идентификатор);
		Адрес = Стр.ХранилищеКартинкиВременное;
		ДвДанные = ПолучитьИзВременногоХранилища(Адрес);
		Если НЕ ДвДанные = Неопределено Тогда
			Найд.ХранилищеКартинки = Новый ХранилищеЗначения(ДвДанные);
			МассивАдресовДляУдаления.Добавить(Адрес);
			Стр.ХранилищеКартинкиВременное = "";
		КонецЕсли; 
		
	КонецЦикла; 
	// - 03.07.2018 13:50:38 Базунов Д.А. Задача:
	
	БизнесПроцессОбъект.Характеристики.Загрузить(Характеристики.Выгрузить());
	БизнесПроцессОбъект.Аналоги.Загрузить(Аналоги.Выгрузить());
	
	Попытка
		
		БизнесПроцессОбъект.Записать();
		
		Для каждого Адрес Из МассивАдресовДляУдаления Цикл
			УдалитьИзВременногоХранилища(Адрес);
		КонецЦикла; 
		
		Возврат Истина;
		
	Исключение
		
		Сообщить(ОписаниеОшибки());
		Возврат Ложь;
		
	КонецПопытки;
	
КонецФункции

&НаКлиенте
Процедура Дополнительно(Команда)
	
	БизнесПроцессыИЗадачиКлиент.ОткрытьДопИнформациюОЗадаче(Объект.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область СобытияПредметыСнабжения

&НаКлиенте
Процедура ПредметыСнабженияПередНачаломИзменения(Элемент, Отказ)
	
	Если Элементы.ПредметыСнабжения.ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПредыдущийИдентификатор = Элементы.ПредметыСнабжения.ТекущиеДанные.Идентификатор;
	ПредыдущийПредметСнабжения = Элементы.ПредметыСнабжения.ТекущиеДанные.ПредметСнабжения; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияПриИзменении(Элемент)
	
	Если Элементы.ПредметыСнабжения.ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	//Если Не Элементы.ПредметыСнабжения.ТекущийЭлемент = Элементы.ПредметыСнабженияСогласовано 
	//	И Не Элементы.ПредметыСнабжения.ТекущийЭлемент = Элементы.ПредметыСнабженияПримечание И Элементы.ПредметыСнабженияСогласовано.Видимость Тогда
	//
	//	Элементы.ПредметыСнабжения.ТекущиеДанные.Согласовано = Истина;
	//	
	//КонецЕсли;
	
	ИмяТекущегоЭлемента = Элементы.ПредметыСнабжения.ТекущийЭлемент.Имя;
	ИмяТекущегоЭлемента = Прав(ИмяТекущегоЭлемента, СтрДлина(ИмяТекущегоЭлемента) - 17);
	
	ТекущиеДанные = Элементы.ПредметыСнабжения.ТекущиеДанные;
	
	Попытка
	
		Если ИмяТекущегоЭлемента = "ДатаЦены" Или ИмяТекущегоЭлемента = "Цена" И Не ЗначениеЗаполнено(ТекущиеДанные[ИмяТекущегоЭлемента]) Тогда
			
			ТекущиеДанные[ИмяТекущегоЭлемента + "Изменено"] = Ложь;
			
		Иначе
			
			ТекущиеДанные[ИмяТекущегоЭлемента + "Изменено"] = (ТекущиеДанные[ИмяТекущегоЭлемента] <> ТекущиеДанные[ИмяТекущегоЭлемента + "БД"]);
			
		КонецЕсли;
		
	Исключение
		
	КонецПопытки;
	
	ТекущиеДанные.ЕстьИзменения = ТекущиеДанные.НаименованиеИзменено Или ТекущиеДанные.ОбозначениеИзменено Или ТекущиеДанные.ДокументНаПоставкуИзменено
		Или ТекущиеДанные.ВозможностьИзготовленияИзменено Или ТекущиеДанные.СрокИзготовленияИзменено Или ТекущиеДанные.ЦенаИзменено Или ТекущиеДанные.ДатаЦеныИзменено
		Или ТекущиеДанные.ПравилаУпаковкиТранспортировкиХраненияИзменено;
		
	СтрокиХарактеристики = Характеристики.НайтиСтроки(Новый Структура("Идентификатор, ЕстьИзменения", ТекущиеДанные.Идентификатор, Истина));
	
	Для каждого СтрокаХарактеристика Из СтрокиХарактеристики Цикл
		
		ТекущиеДанные.ЕстьИзменения = ТекущиеДанные.ЕстьИзменения Или СтрокаХарактеристика.ЕстьИзменения; 
		
	КонецЦикла;
		
	УстановитьОтборСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура ХарактеристикиПриИзменении(Элемент)
	
	ИмяТекущегоЭлемента = Элементы.Характеристики.ТекущийЭлемент.Имя;
	ИмяТекущегоЭлемента = Прав(ИмяТекущегоЭлемента, СтрДлина(ИмяТекущегоЭлемента) - 14);
	
	ТекущиеДанные = Элементы.Характеристики.ТекущиеДанные;
	
	Попытка
	
		ТекущиеДанные[ИмяТекущегоЭлемента + "Изменено"] = (ТекущиеДанные[ИмяТекущегоЭлемента] <> ТекущиеДанные[ИмяТекущегоЭлемента + "БД"]);
		
	Исключение
		
	КонецПопытки;
	
	ТекущиеДанные.ЕстьИзменения = ТекущиеДанные.ЕдиницаИзмеренияИзменено Или ТекущиеДанные.ЗначениеИзменено Или ТекущиеДанные.ОсновнаяИзменено;
	
	СтрокиПредметСнабжения = ПредметыСнабжения.НайтиСтроки(Новый Структура("Идентификатор", ТекущиеДанные.Идентификатор));
		
	Если СтрокиПредметСнабжения.Количество() > 0 Тогда
			
		СтрокиПредметСнабжения[0].ЕстьИзменения = СтрокиПредметСнабжения[0].НаименованиеИзменено Или СтрокиПредметСнабжения[0].ОбозначениеИзменено 
			Или СтрокиПредметСнабжения[0].ДокументНаПоставкуИзменено Или СтрокиПредметСнабжения[0].ВозможностьИзготовленияИзменено 
				Или СтрокиПредметСнабжения[0].СрокИзготовленияИзменено Или СтрокиПредметСнабжения[0].ЦенаИзменено Или СтрокиПредметСнабжения[0].ДатаЦеныИзменено
					Или СтрокиПредметСнабжения[0].ПравилаУпаковкиТранспортировкиХраненияИзменено Или ТекущиеДанные.ЕстьИзменения;
			
	КонецЕсли;
		
	УстановитьОтборСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияПредметСнабженияПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ПредметыСнабжения.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(ТекущиеДанные.ПредметСнабжения) И 
		ПредметыСнабжения.НайтиСтроки(Новый Структура("ПредметСнабжения", ТекущиеДанные.ПредметСнабжения)).Количество() > 1 Тогда
		
		Сообщить("В таблице уже есть такой предмет снабжения!");
		ТекущиеДанные.ПредметСнабжения = ПредыдущийПредметСнабжения;
		Возврат;
		
	КонецЕсли;	
	
	УдалитьХарактеристикиАналогиПредметаСнабжения();		
	
	ДанныеПредметаСнабжения = ЗаполнитьДанныеПредметаСнабжения(ТекущиеДанные.ПредметСнабжения);
	
	ТекущиеДанные.Идентификатор = ?(ЗначениеЗаполнено(ТекущиеДанные.ПредметСнабжения), ТекущиеДанные.ПредметСнабжения.УникальныйИдентификатор(), "");
	
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ДанныеПредметаСнабжения);
	
КонецПроцедуры

&НаСервере
Функция ЗаполнитьДанныеПредметаСнабжения(ПредметСнабжения)
	
	//основные данные
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.ПредметСнабжения КАК ПредметСнабжения,
	|	ВложенныйЗапрос.Наименование КАК Наименование,
	|	ВложенныйЗапрос.Обозначение КАК Обозначение,
	|	ВложенныйЗапрос.ДокументНаПоставку КАК ДокументНаПоставку,
	|	ВложенныйЗапрос.ВозможностьИзготовления КАК ВозможностьИзготовления,
	|	ВложенныйЗапрос.ПравилаУпаковкиТранспортировкиХранения КАК ПравилаУпаковкиТранспортировкиХранения,
	|	ВложенныйЗапрос.ИмяФайлаКартинки КАК ИмяФайлаКартинки,
	|	ВложенныйЗапрос.СрокИзготовления КАК СрокИзготовления,
	|	ВложенныйЗапрос.Входимость КАК Входимость,
	|	ЕСТЬNULL(ЦеныПредметовСнабженияСрезПоследних.Цена, 0) КАК Цена,
	|	ЕСТЬNULL(ЦеныПредметовСнабженияСрезПоследних.Период, ДАТАВРЕМЯ(1, 1, 1)) КАК ДатаЦены
	|ИЗ
	|	(ВЫБРАТЬ
	|		ВложенныйЗапрос.ПредметСнабжения КАК ПредметСнабжения,
	|		ВложенныйЗапрос.Наименование КАК Наименование,
	|		ВложенныйЗапрос.Обозначение КАК Обозначение,
	|		ВложенныйЗапрос.ДокументНаПоставку КАК ДокументНаПоставку,
	|		ВложенныйЗапрос.ВозможностьИзготовления КАК ВозможностьИзготовления,
	|		ВложенныйЗапрос.ПравилаУпаковкиТранспортировкиХранения КАК ПравилаУпаковкиТранспортировкиХранения,
	|		ВложенныйЗапрос.ИмяФайлаКартинки КАК ИмяФайлаКартинки,
	|		ВложенныйЗапрос.СрокИзготовления КАК СрокИзготовления,
	|		МАКСИМУМ(ЕСТЬNULL(СпецификацииПредметовСнабжения.ПредметСнабжения, ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка))) КАК Входимость
	|	ИЗ
	|		(ВЫБРАТЬ
	|			ВложенныйЗапрос.ПредметСнабжения КАК ПредметСнабжения,
	|			ВложенныйЗапрос.Наименование КАК Наименование,
	|			ВложенныйЗапрос.Обозначение КАК Обозначение,
	|			ВложенныйЗапрос.ДокументНаПоставку КАК ДокументНаПоставку,
	|			ВложенныйЗапрос.ВозможностьИзготовления КАК ВозможностьИзготовления,
	|			ВложенныйЗапрос.ПравилаУпаковкиТранспортировкиХранения КАК ПравилаУпаковкиТранспортировкиХранения,
	|			ВложенныйЗапрос.ИмяФайлаКартинки КАК ИмяФайлаКартинки,
	|			МАКСИМУМ(ВЫБОР
	|					КОГДА ЕСТЬNULL(КаталогПредметовСнабженияИзготовителиИПоставщики.ЕдиницаИзмерения, НЕОПРЕДЕЛЕНО) = &День
	|						ТОГДА КаталогПредметовСнабженияИзготовителиИПоставщики.СрокиИзготовления
	|					ИНАЧЕ 0
	|				КОНЕЦ) КАК СрокИзготовления
	|		ИЗ
	|			(ВЫБРАТЬ
	|				КаталогПредметовСнабжения.Ссылка КАК ПредметСнабжения,
	|				КаталогПредметовСнабжения.Наименование КАК Наименование,
	|				КаталогПредметовСнабжения.Обозначение КАК Обозначение,
	|				КаталогПредметовСнабжения.ДокументНаПоставку КАК ДокументНаПоставку,
	|				ЛОЖЬ КАК ВозможностьИзготовления,
	|				ВЫРАЗИТЬ(КаталогПредметовСнабжения.ПравилаУпаковкиТранспортировкиХранения КАК СТРОКА(200)) КАК ПравилаУпаковкиТранспортировкиХранения,
	|				"""" КАК ИмяФайлаКартинки
	|			ИЗ
	|				Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	|			ГДЕ
	|				КаталогПредметовСнабжения.Ссылка = &ПредметСнабжения) КАК ВложенныйЗапрос
	|				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КаталогПредметовСнабжения.ИзготовителиИПоставщики КАК КаталогПредметовСнабженияИзготовителиИПоставщики
	|				ПО ВложенныйЗапрос.ПредметСнабжения = КаталогПредметовСнабженияИзготовителиИПоставщики.Ссылка
	|					И (КаталогПредметовСнабженияИзготовителиИПоставщики.Контрагент = &Поставщик)
	|		
	|		СГРУППИРОВАТЬ ПО
	|			ВложенныйЗапрос.ИмяФайлаКартинки,
	|			ВложенныйЗапрос.ДокументНаПоставку,
	|			ВложенныйЗапрос.ВозможностьИзготовления,
	|			ВложенныйЗапрос.Обозначение,
	|			ВложенныйЗапрос.Наименование,
	|			ВложенныйЗапрос.ПредметСнабжения,
	|			ВложенныйЗапрос.ПравилаУпаковкиТранспортировкиХранения) КАК ВложенныйЗапрос
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.СпецификацииПредметовСнабжения КАК СпецификацииПредметовСнабжения
	|			ПО ВложенныйЗапрос.ПредметСнабжения = СпецификацииПредметовСнабжения.СоставляющаяЧасть
	|	
	|	СГРУППИРОВАТЬ ПО
	|		ВложенныйЗапрос.ПредметСнабжения,
	|		ВложенныйЗапрос.Наименование,
	|		ВложенныйЗапрос.Обозначение,
	|		ВложенныйЗапрос.ДокументНаПоставку,
	|		ВложенныйЗапрос.ВозможностьИзготовления,
	|		ВложенныйЗапрос.ПравилаУпаковкиТранспортировкиХранения,
	|		ВложенныйЗапрос.ИмяФайлаКартинки,
	|		ВложенныйЗапрос.СрокИзготовления) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ЦеныПредметовСнабжения.СрезПоследних КАК ЦеныПредметовСнабженияСрезПоследних
	|		ПО ВложенныйЗапрос.ПредметСнабжения = ЦеныПредметовСнабженияСрезПоследних.ПредметСнабжения
	|			И (ЦеныПредметовСнабженияСрезПоследних.ТипЦены = ЗНАЧЕНИЕ(Перечисление.ТипыЦен.Внутренняя))
	|			И (ЦеныПредметовСнабженияСрезПоследних.Контрагент = &Поставщик)";
	Запрос.УстановитьПараметр("ПредметСнабжения", ПредметСнабжения);
	Запрос.УстановитьПараметр("Поставщик", Объект.Предмет);
	Запрос.УстановитьПараметр("День", Константы.ЕдиницаИзмеренияДень.Получить());
	
	ТаблицаЗапроса = Запрос.Выполнить().Выгрузить();
	
	ЕстьДанные = (ТаблицаЗапроса.Количество() > 0);
	
	Результат = Новый Структура;
	
	Для каждого Колонка Из ТаблицаЗапроса.Колонки Цикл
		
		Значение = ?(ЕстьДанные, ТаблицаЗапроса[0][Колонка.Имя], Неопределено);
		
		Результат.Вставить(Колонка.Имя, Значение);
		Результат.Вставить(Колонка.Имя + "БД", Значение);
		
	КонецЦикла;
	
	//характеристики
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Характеристика КАК Характеристика,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ВложенныйЗапрос.Значение КАК Значение,
	|	ВложенныйЗапрос.Основная КАК Основная,
	|	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВложенныйЗапрос.Характеристика) КАК Наименование,
	|	ЕСТЬNULL(ОКЕИ.Код, """") КАК ЕдиницаИзмеренияКод,
	|	&ПредметСнабжения КАК ПредметСнабжения,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмеренияБД,
	|	ВложенныйЗапрос.Значение КАК ЗначениеБД,
	|	ВложенныйЗапрос.Основная КАК ОсновнаяБД
	|ИЗ
	|	(ВЫБРАТЬ
	|		КаталогПредметовСнабженияХарактеристики.Характеристика КАК Характеристика,
	|		КаталогПредметовСнабженияХарактеристики.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		КаталогПредметовСнабженияХарактеристики.Значение КАК Значение,
	|		КаталогПредметовСнабженияХарактеристики.Основная КАК Основная
	|	ИЗ
	|		Справочник.КаталогПредметовСнабжения.Характеристики КАК КаталогПредметовСнабженияХарактеристики
	|	ГДЕ
	|		КаталогПредметовСнабженияХарактеристики.Ссылка = &ПредметСнабжения) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ОКЕИ КАК ОКЕИ
	|		ПО ВложенныйЗапрос.ЕдиницаИзмерения = ОКЕИ.Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		СтрокаХарактеристика = Характеристики.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаХарактеристика, Выборка);
		СтрокаХарактеристика.Идентификатор = ПредметСнабжения.УникальныйИдентификатор();
		
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

&НаКлиенте
Процедура ПредметыСнабженияПередУдалением(Элемент, Отказ)
	
	Если Элементы.ПредметыСнабжения.ТекущиеДанные = Неопределено Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ПредыдущийИдентификатор = Элементы.ПредметыСнабжения.ТекущиеДанные.Идентификатор;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияПослеУдаления(Элемент)
	
	 УдалитьХарактеристикиАналогиПредметаСнабжения();
	
КонецПроцедуры

&НаКлиенте
Процедура УдалитьХарактеристикиАналогиПредметаСнабжения()
	
	Если Не ЗначениеЗаполнено(ПредыдущийИдентификатор) Тогда
		
		Возврат;
		
	КонецЕсли;
	
	ХарактеристикиПС = Характеристики.НайтиСтроки(Новый Структура("Идентификатор", ПредыдущийИдентификатор));
	
	Для каждого СтрокаХарактеристика Из ХарактеристикиПС Цикл
		
		Характеристики.Удалить(СтрокаХарактеристика);
		
	КонецЦикла;
	
	АналогиПС = Аналоги.НайтиСтроки(Новый Структура("Идентификатор", ПредыдущийИдентификатор));
	
	Для каждого СтрокаАналог Из АналогиПС Цикл
		
		Аналоги.Удалить(СтрокаАналог);
		
	КонецЦикла;
	
	АналогиПС = Аналоги.НайтиСтроки(Новый Структура("ИдентификаторАналога", ПредыдущийИдентификатор));
	
	Для каждого СтрокаАналог Из АналогиПС Цикл
		
		Аналоги.Удалить(СтрокаАналог);
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияПриАктивизацииСтроки(Элемент)
	
	ЗаполнитьХарактеристикиПредметаСнабжения();
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьХарактеристикиПредметаСнабжения()
	
	Если Элементы.ХарактеристикиПредметаСнабжения.Видимость И Не Элементы.ПредметыСнабжения.ТекущиеДанные = Неопределено Тогда
		
		ХарактеристикиПредметаСнабжения.Очистить();
		
		МассивХарактеристик = Характеристики.НайтиСтроки(Новый Структура("Идентификатор", Элементы.ПредметыСнабжения.ТекущиеДанные.Идентификатор));
		
		Если МассивХарактеристик.Количество() = 0 Тогда
			
			Возврат;
			
		КонецЕсли;
		
		Для каждого ЭлементМассиваХарактеристик Из МассивХарактеристик Цикл
			
			СтрокаХарактеристик = ХарактеристикиПредметаСнабжения.Добавить();
			ЗаполнитьЗначенияСвойств(СтрокаХарактеристик, ЭлементМассиваХарактеристик);
			
		КонецЦикла;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПредметыСнабженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "ПредметыСнабженияИмяФайлаКартинки" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекДанные = Элементы.ПредметыСнабжения.ТекущиеДанные;
		ИмяКартинки = ТекДанные.ИмяФайлаКартинки;
		
		Если НЕ ИмяКартинки = "" И ЭтоАдресВременногоХранилища(ТекДанные.ХранилищеКартинкиВременное) Тогда
			ДвоичныеДанные = ПолучитьИзВременногоХранилища(ТекДанные.ХранилищеКартинкиВременное);
			Если НЕ ДвоичныеДанные = Неопределено Тогда
				ИмяФайла = КаталогВременныхФайлов() + ИмяКартинки;
				ДвоичныеДанные.Записать(ИмяФайла);
				ЗапуститьПриложение(ИмяФайла);			
			КонецЕсли; 
		КонецЕсли; 
		
	ИначеЕсли Элементы.ПредметыСнабжения.ТолькоПросмотр Тогда
	
		ПоказатьЗначение(, Элементы.ПредметыСнабжения.ТекущиеДанные.ПредметСнабжения);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ДобавитьФайлВПрисоединенныеФайлы(ПутьКФайлу, АдресВоВременномХранилище)
	
	ПолныйФайл= ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПутьКФайлу);
	ИмяБезРасширения   = ПолныйФайл.ИмяБезРасширения;
	РасширениеБезТочки = СтрЗаменить(ПолныйФайл.Расширение, ".", "");
	
	ПараметрыФайла = Новый Структура;
	ПараметрыФайла.Вставить("ВладелецФайлов",              Объект.БизнесПроцесс);
	ПараметрыФайла.Вставить("Автор",                       ПараметрыСеанса.ТекущийПользователь);
	ПараметрыФайла.Вставить("ИмяБезРасширения",            ИмяБезРасширения);
	ПараметрыФайла.Вставить("РасширениеБезТочки",          РасширениеБезТочки);
	ПараметрыФайла.Вставить("ВремяИзменения",              Неопределено);
	ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
	
	ПрисоединенныеФайлы.ДобавитьПрисоединенныйФайл(ПараметрыФайла, АдресВоВременномХранилище, "", "");
	
КонецПроцедуры

&НаСервере
Процедура ИнициализацияФормы()
	
	Если ЗначениеЗаполнено(Объект.БизнесПроцесс) Тогда
		ПараметрыФормы = БизнесПроцессыИЗадачиВызовСервера.ФормаВыполненияЗадачи(Объект.Ссылка);
		ЕстьФормаЗадачи = ПараметрыФормы.Свойство("ИмяФормы");
		//Элементы.ГруппаФормаВыполнения.Видимость = ЕстьФормаЗадачи;
		Элементы.Выполнена.Доступность = НЕ ЕстьФормаЗадачи;
	//Иначе
	//	Элементы.ГруппаФормаВыполнения.Видимость = Ложь;
	КонецЕсли;
	НачальныйПризнакВыполнения = Объект.Выполнена;
	Если Объект.Ссылка.Пустая() Тогда
		Объект.Важность = Перечисления.ВариантыВажностиЗадачи.Обычная;
		Объект.СрокИсполнения = ТекущаяДатаСеанса();
	КонецЕсли;
	
	Элементы.Предмет.Гиперссылка = Объект.Предмет <> Неопределено И НЕ Объект.Предмет.Пустая();
	ПредметСтрокой = ОбщегоНазначения.ПредметСтрокой(Объект.Предмет);	
	
	ИспользоватьДатуИВремяВСрокахЗадач = ПолучитьФункциональнуюОпцию("ИспользоватьДатуИВремяВСрокахЗадач");
	Элементы.СрокНачалаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	Элементы.ДатаИсполненияВремя.Видимость = ИспользоватьДатуИВремяВСрокахЗадач;
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.СрокИсполнения);
	БизнесПроцессыИЗадачиСервер.УстановитьФорматДаты(Элементы.Дата);
	
	БизнесПроцессыИЗадачиСервер.ФормаЗадачиПриСозданииНаСервере(ЭтотОбъект, Объект, 
		Элементы.ГруппаСостояние, Элементы.ДатаИсполнения);
		
	Если ПользователиКлиентСервер.ЭтоСеансВнешнегоПользователя() Тогда
		Элементы.Автор.Видимость = Ложь;
		Элементы.АвторСтрокой.Видимость = Истина;
		Элементы.Исполнитель.КнопкаОткрытия = Ложь;
	КонецЕсли;
	
	Элементы.Выполнена.Доступность = ПравоДоступа("Изменение", Метаданные.Задачи.ЗадачаИсполнителя);
	
	// + 16.01.2018 10:58:37 Базунов Д.А. Задача: 

	Если НЕ Объект.Описание = "" Тогда
		Элементы.Описание.Видимость = Истина;
	Иначе
		Элементы.Описание.Видимость = Ложь;
	КонецЕсли; 
	
	Если Объект.РольИсполнителя.Пустая() Тогда
		Элементы.РольИсполнителя.Видимость = Ложь;
		Элементы.Исполнитель.Видимость = Истина;
	Иначе
		Элементы.РольИсполнителя.Видимость = Истина;
		Элементы.Исполнитель.Видимость = Ложь;
	КонецЕсли;
	
	ТочкиМаршрута = БизнесПроцессы.ВзаимодействиеСРОЭ.ТочкиМаршрута;
	
	Если Объект.ТочкаМаршрута = ТочкиМаршрута.ОжиданиеПолученияОтвета Тогда
		Элементы.ТаблицаПредметовСнабжения.ТолькоПросмотр = Истина;
		Элементы.ГруппаВариантыВыбора.Видимость = Истина;
		Элементы.Отклонить.Видимость = Истина;
	ИначеЕсли Объект.ТочкаМаршрута = ТочкиМаршрута.ОбновлениеДанныхВКаталогеПС Тогда
		ТолькоПросмотр = Истина;
		Элементы.ГруппаВариантыВыбора.Видимость = Ложь;
	КонецЕсли; 
	
	Если Объект.Выполнена Тогда
		Элементы.Выполнена.Доступность = Ложь;
		Элементы.ДатаИсполнения.Доступность = Ложь;
		Элементы.ДатаИсполненияВремя.Доступность = Ложь;
		Элементы.ГруппаВариантыВыбора.Доступность = Ложь;
		Элементы.Отклонить.Доступность = Ложь;
	КонецЕсли;
	
	// - 16.01.2018 10:58:37 Базунов Д.А. Задача: 
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицаПредметовСнабженияВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ПоказатьЗначение(, Элемент.ТекущиеДанные.ПредметСнабжения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если СокрЛП(Объект.РезультатВыполнения) = "" Тогда
		Если Объект.ВыбранныйВариант = "" Тогда
			Объект.РезультатВыполнения = "Выполнена";
		Иначе
			Объект.РезультатВыполнения = СокрЛП(Объект.ВыбранныйВариант);
		КонецЕсли; 
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьИзФайла(Команда)
	
	РезультатЗагрузки = КорректировкаДанныхСправочниковКлиент.ЗагрузитьФайлОтПоставщика(ЭтаФорма, Ложь);
	
	Если ЗначениеЗаполнено(РезультатЗагрузки) Тогда
		
		СравнитьСДаннымиБД();
	
 		АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(РезультатЗагрузки));

		ДобавитьФайлВПрисоединенныеФайлы(РезультатЗагрузки, АдресВоВременномХранилище);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Отклонить(Команда)
	
	Объект.ВыбранныйВариант = "Отклонено";
	
	БизнесПроцессыИЗадачиКлиент.ЗаписатьИЗакрытьВыполнить(ЭтотОбъект, Истина);	
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВсе(Команда)
	
	УстановитьСнятьФлажки(Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьВсе(Команда)
	
	УстановитьСнятьФлажки(Ложь);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьСнятьФлажки(ЗначениеФлажка)
	
	Для каждого СтрокаПредметСнабжения Из ПредметыСнабжения Цикл
		
		СтрокаПредметСнабжения.Согласовано = ЗначениеФлажка;
		
	КонецЦикла;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьДанныеБД(Команда)
	
	СравнитьСДаннымиБД();
	
КонецПроцедуры

&НаСервере
Процедура СравнитьСДаннымиБД()
	
	КорректировкаДанныхСправочников.ВыполнитьСравнениеСДаннымиБД(ПредметыСнабжения, Характеристики, Объект.Предмет);
	
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если Не ЗафиксироватьПолученныеДанные() Тогда
		
		Отказ = Истина;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТолькоИзмененныеПриИзменении(Элемент)
	
	УстановитьОтборСтрок();
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборСтрок()
	
	ОтборСтрок = ?(ТолькоИзмененные, Новый ФиксированнаяСтруктура("ЕстьИзменения", Истина), Неопределено);
	
	Элементы.ПредметыСнабжения.ОтборСтрок = ОтборСтрок;
	Элементы.Характеристики.ОтборСтрок = ОтборСтрок;
	Элементы.ХарактеристикиПредметаСнабжения.ОтборСтрок = ОтборСтрок;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьХарактеристикиПредметаСнабженияПриИзменении(Элемент)
	
	Элементы.ГруппаХарактеристикиПредметаСнабжения.Видимость = ОтображатьХарактеристикиПредметаСнабжения;
	
	ЗаполнитьХарактеристикиПредметаСнабжения();
	
КонецПроцедуры

#КонецОбласти
