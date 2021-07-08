///////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область Сервис

&НаКлиенте
Процедура ДиалогПриВыбореФайла()
	
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	
	ДиалогОткрытияФайла.ПолноеИмяФайла 	= ИмяФайла;
	ДиалогОткрытияФайла.Заголовок 		= "Файл с данными тендера";
	ДиалогОткрытияФайла.Фильтр			= "Файлы excel|*.xls;*.xlsx";
	
	ДиалогОткрытияФайла.Показать(Новый ОписаниеОповещения("ПослеВыбораФайла", ЭтаФорма));	
	
КонецПроцедуры	//ДиалогПриВыбореФайла

&НаКлиенте
Процедура СнятьУстановитьОтборДублей(ОтключитьПринудительно = Ложь)
	
	Если Элементы.ТаблицаДанных.ОтборСтрок = Неопределено И Не ОтключитьПринудительно Тогда
		
		СтруктураОтбор = Новый ФиксированнаяСтруктура("ЕстьДубли", Истина);
		Элементы.ТаблицаДанных.ОтборСтрок = СтруктураОтбор;
		ТаблицаДанных.Сортировать("ПредметСнабжения, ПорядокСтроки");
		Элементы.ТаблицаДанныхКомандаОтборДублей.Пометка = Истина;
	Иначе
		Элементы.ТаблицаДанных.ОтборСтрок 					= Неопределено;
		Элементы.ТаблицаДанныхКомандаОтборДублей.Пометка 	= Ложь;
		ТаблицаДанных.Сортировать("ПорядокСтроки");
		
		ПеренумероватьСтрокиВТаблице();
		
    КонецЕсли; // Если Элементы.ТаблицаДанных.ОтборСтрок = Неопределено И Не ОтключитьПринудительно Тогда
	
	РезПроверки = ПроверкаНаДубли();
	ОбновитьКнопкуОтборДублей(РезПроверки.Дублей);
	
КонецПроцедуры	//СнятьУстановитьОтборДублей

&НаКлиенте
Процедура УдалитьВыделеннуюСтроку()
	
	Если Элементы.ТаблицаДанных.ВыделенныеСтроки.Количество() > 0 Тогда
	
		ТаблицаДанных.Удалить(ТаблицаДанных.НайтиПоИдентификатору(Элементы.ТаблицаДанных.ВыделенныеСтроки[0]));
	
		РезПроверкиДублей = ПроверкаНаДубли();
		ОбновитьКнопкуОтборДублей(РезПроверкиДублей.Дублей);
		
		Если Не Элементы.ТаблицаДанныхКомандаОтборДублей.Пометка Тогда
		
			ПеренумероватьСтрокиВТаблице();
			
		КонецЕсли;
		
	КонецЕсли;

КонецПроцедуры	//УдалитьВыделеннуюСтроку

&НаСервере
Процедура ЗаполнениеТаблицыДанных()
		
	ТаблицаДанных.Очистить();
	
	Для НомерСтроки = НомерПервойСтроки По НомерПоследнейСтроки Цикл
		
		НоваяСтрока 						= ТаблицаДанных.Добавить();
		НоваяСтрока.ИДСтроки		 		= Строка(Новый УникальныйИдентификатор);
		
		НоваяСтрока.Обозначение 	 		= ПолучитьЗначение(НомерСтроки, КолонкаКодПС);
		НоваяСтрока.Наименование 	 		= ПолучитьЗначение(НомерСтроки, КолонкаНаименованиеПС);
		Если КолонкаШифрМарка > 0 Тогда
			НоваяСтрока.ШифрМарка 	 		= ПолучитьЗначение(НомерСтроки, КолонкаШифрМарка);	
		КонецЕсли; // Если КолонкаШифрМарка > 0 Тогда
		Если КолонкаДокументНаПоставку > 0 Тогда
			НоваяСтрока.ДокументНаПоставку 	 = ПолучитьЗначение(НомерСтроки, КолонкаДокументНаПоставку);	
		КонецЕсли; // Если КолонкаШифрМарка > 0 Тогда
		НоваяСтрока.Количество 		 		= ПолучитьЗначение(НомерСтроки, КолонкаКоличество, 	Истина);
		НоваяСтрока.Цена 			 		= ПолучитьЗначение(НомерСтроки, КолонкаЦена, 		Истина);
		
		Если КолонкаСрокПоставки > 0 Тогда 
			НоваяСтрока.СрокПоставки 		= ПолучитьЗначение(НомерСтроки, КолонкаСрокПоставки, Истина);
		КонецЕсли; // Если КолонкаСрокПоставки > 0 Тогда 
		
		Если КолонкаКомментарий > 0 Тогда
			НоваяСтрока.Комментарий      	= ПолучитьЗначение(НомерСтроки, КолонкаКомментарий);
		КонецЕсли; // Если КолонкаКомментарий > 0 Тогда
	КонецЦикла; // Для НомерСтроки = НомерПервойСтроки По НомерПоследнейСтроки Цикл
		
	ЗаполнитьПредметыСнабжения();
	
	ПеренумероватьСтрокиВТаблице();
	
		
КонецПроцедуры	//ЗаполнениеТаблицыДанных

&НаСервере
Процедура ПоместитьСтрокиВТаблицуБыстрогоПоиска(МассивСтрок, ИдСтрока, ПоискПоНаименованию)
	
	Если МассивСтрок.Количество() > 0 Тогда
		Для Каждого элМассива из МассивСтрок Цикл
			нСтрока = ТаблицаБыстрогоПоиска.Добавить();
			рСтрока = ТаблицаБыстрогоПоиска.НайтиПоИдентификатору(нСтрока.ПолучитьИдентификатор());
			рСтрока.ПредметСнабжения 	= элМассива.Значение;
			рСтрока.ОбозначениеПС 		= рСтрока.ПредметСнабжения.Обозначение; 
			рСтрока.ДокументНаПоставку 	= рСтрока.ПредметСнабжения.ДокументНаПоставку; 
			рСтрока.ИДСтроки 			= ИдСтрока;
			рСтрока.ПоискПоНаименованию = ПоискПоНаименованию;
		КонецЦикла;
	КонецЕсли;

КонецПроцедуры	//ПоместитьСтрокиВТаблицуБыстрогоПоиска

&НаСервере
Функция СформироватьСтрокуАвтоподбора(Строка, ПоискПоНаименованию = Ложь)

	Ответ = "";
	
	Если ПоискПоНаименованию Тогда
		Если ЗначениеЗаполнено(Строка.ПредметСнабжения) Тогда
			Ответ = "" + Строка.ПредметСнабжения; 	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ответ) И ЗначениеЗаполнено(Строка.ОбозначениеПС) Тогда
			Ответ = Ответ + " - " + Строка.ОбозначениеПС; 	
		ИначеЕсли ЗначениеЗаполнено(Строка.ОбозначениеПС) Тогда
			Ответ = "" + Строка.ОбозначениеПС; 	
		КонецЕсли;

	Иначе
		Если ЗначениеЗаполнено(Строка.ОбозначениеПС) Тогда
			Ответ = "" + Строка.ОбозначениеПС; 	
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Ответ) И ЗначениеЗаполнено(Строка.ПредметСнабжения) Тогда
			Ответ = Ответ + " - " + Строка.ПредметСнабжения; 	
		ИначеЕсли ЗначениеЗаполнено(Строка.ПредметСнабжения) Тогда
			Ответ = "" + Строка.ПредметСнабжения; 	
		КонецЕсли;
		
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Ответ) И ЗначениеЗаполнено(Строка.ДокументНаПоставку) Тогда
		Ответ = Ответ + " - " + Строка.ДокументНаПоставку; 	
	ИначеЕсли ЗначениеЗаполнено(Строка.ДокументНаПоставку) Тогда
		Ответ = "" + Строка.ДокументНаПоставку; 	
	КонецЕсли; //Если ЗначениеЗаполнено(Ответ) И ЗначениеЗаполнено(Строка.ДокументНаПоставку) Тогда

	Возврат Ответ;
	
КонецФункции // СформироватьСтрокуАвтоподбора()

&НаСервере
Процедура УстановитьПараметрыПоУмолчанию()
    СохранятьФайлИсточник = Истина;
	НомерПервойСтроки = 1;
	УстановитьВидимостьПоУмолчанию();
КонецПроцедуры	//УстановитьПараметрыПоУмолчанию

&НаСервере
Процедура УстановитьВидимостьПоУмолчанию()

КонецПроцедуры	//УстановитьВидимостьПоУмолчанию

&НаСервере
Функция ПолучитьТаблицуБезДублей()
	
	ТекТабл = ТаблицаДанных.Выгрузить();
	
	//убираю возможные дубли
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	ТекТабл.ПредметСнабжения КАК ПредметСнабжения,
	|	ТекТабл.Цена КАК Цена,
	|	ТекТабл.Количество КАК Количество,
	|	ТекТабл.НомерСтроки КАК НомерСтроки,
	|	ТекТабл.СрокПоставки КАК СрокПоставки,
	|	ТекТабл.РезультатовПоиска КАК РезультатовПоиска,
	|	ПОДСТРОКА(ТекТабл.Наименование, 0, 100) КАК Наименование,
	|	ПОДСТРОКА(ТекТабл.Обозначение, 0 , 100) КАК Обозначение,
	|	ТекТабл.ИДСтроки КАК ИДСтроки
	|ПОМЕСТИТЬ ВТ_источник
	|ИЗ
	|	&ТекТабл КАК ТекТабл
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВТ_источник.ПредметСнабжения КАК ПредметСнабжения,
	|	МАКСИМУМ(ВТ_источник.Цена) КАК Цена,
	|	МАКСИМУМ(ВТ_источник.Количество) КАК Количество,
	|	МАКСИМУМ(ВТ_источник.НомерСтроки) КАК НомерСтроки,
	|	МАКСИМУМ(ВТ_источник.СрокПоставки) КАК СрокПоставки,
	|	МАКСИМУМ(ВТ_источник.РезультатовПоиска) КАК РезультатовПоиска,
	|	МАКСИМУМ(ВТ_источник.Наименование) КАК Наименование,
	|	МАКСИМУМ(ВТ_источник.Обозначение) КАК Обозначение,
	|	МАКСИМУМ(ВТ_источник.ИДСтроки) КАК ИДСтроки
	|ИЗ
	|	ВТ_источник КАК ВТ_источник
	|
	|СГРУППИРОВАТЬ ПО
	|	ВТ_источник.ПредметСнабжения";
	
	Запрос.Параметры.Вставить("ТекТабл", ТекТабл);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции	//ПолучитьТаблицуБезДублей

&НаСервере
Функция ПолучитьТаблицуДублирующизсяПС()
	
	ТекТабл = ТаблицаДанных.Выгрузить();
	
	//убираю возможные дубли
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТекТабл.ПредметСнабжения КАК ПредметСнабжения,
	               |	ТекТабл.Цена КАК Цена,
	               |	ТекТабл.Количество КАК Количество,
	               |	ТекТабл.НомерСтроки КАК НомерСтроки,
	               |	ТекТабл.СрокПоставки КАК СрокПоставки,
	               |	ТекТабл.РезультатовПоиска КАК РезультатовПоиска,
	               |	ПОДСТРОКА(ТекТабл.Наименование, 0, 100) КАК Наименование,
	               |	ПОДСТРОКА(ТекТабл.Обозначение, 0, 100) КАК Обозначение,
	               |	ТекТабл.ИДСтроки КАК ИДСтроки
	               |ПОМЕСТИТЬ ВТ_источник
	               |ИЗ
	               |	&ТекТабл КАК ТекТабл
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТ_источник.ПредметСнабжения КАК ПредметСнабжения
	               |ИЗ
	               |	ВТ_источник КАК ВТ_источник
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ВТ_источник.ПредметСнабжения
	               |
	               |ИМЕЮЩИЕ
	               |	КОЛИЧЕСТВО(РАЗЛИЧНЫЕ ВТ_источник.ИДСтроки) > 1";
	
	Запрос.Параметры.Вставить("ТекТабл", ТекТабл);
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции	//ПолучитьТаблицуБезДублей

&НаКлиенте
Процедура ОткрытьОбъектЕслиНеобходимо(СсылкаНаОбъект, НужноОткрыть)
	
	Если НужноОткрыть Тогда
		Описание = Новый ОписаниеОповещения("ПослеОткрытияОбъекта", ЭтаФорма);
		ПоказатьЗначение(Описание, СсылкаНаОбъект);
	КонецЕсли;
	
КонецПроцедуры	//ОткрытьОбъектЕслиНеобходимо

&НаСервере
Процедура ПеренумероватьСтрокиВТаблице()
	
	тНомер = 1;
	
	Для Каждого тСтр Из ТаблицаДанных Цикл
		
		тСтр.ПорядокСтроки = тНомер;
		
		тНомер = тНомер + 1;
		
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОбновитьКнопкуОтборДублей(КоличествоДублей=0)
	
	Если Не Элементы.ТаблицаДанныхКомандаОтборДублей.Пометка Тогда
		
		Элементы.ТаблицаДанныхКомандаОтборДублей.Заголовок = "Отобрать дубли (" + КоличествоДублей + ")";
			
	Иначе	
		
		Элементы.ТаблицаДанныхКомандаОтборДублей.Заголовок = "Отключить отбор (" + КоличествоДублей + ")";
		
	КонецЕсли;
	
КонецПроцедуры	//ОбновитьКнопкуОтборДублей

&НаСервере
Функция ПрочитатьТабличныйДокументНаСервере(АдресВХ, Расширение)
	
	ВремФайл = ПолучитьИмяВременногоФайла(Расширение);
	ДвоичныеДанные = ПолучитьИзВременногоХранилища(АдресВХ);
	ДвоичныеДанные.Записать(ВремФайл);
	
	ТабДок = Новый ТабличныйДокумент;
	ТабДок.Прочитать(ВремФайл);
	УдалитьФайлы(ВремФайл);
	Возврат ТабДок;
	
КонецФункции //ПрочитатьТабличныйДокументНаСервере

&НаСервереБезКонтекста
Функция ПолучитьРасширениеФайла(Знач ИмяФайла)
	
	РасширениеФайла = "";
	МассивСтрок = СтрРазделить(ИмяФайла, ".", Ложь);
	Если МассивСтрок.Количество() > 1 Тогда
		РасширениеФайла = МассивСтрок[МассивСтрок.Количество() - 1];
	КонецЕсли;
	
	Возврат РасширениеФайла;
	
КонецФункции	//ПолучитьРасширениеФайла

&НаКлиенте
Процедура ПолучитьОписаниеИПоказатьПользователю()

	ТекДанные = Элементы.ТаблицаДанных.ТекущиеДанные;
	
	Если ТекДанные <> Неопределено Тогда
		ТекстПредупреждения = "";
		
		РезПоиска = ТекДанные.РезультатовПоиска;
		МетПоиска = ТекДанные.МетодПоиска;
		
		Если РезПоиска = 0 Тогда
			ТекстПредупреждения = "Не нашлось подходящих предметов снабжения.";
			
		ИначеЕсли РезПоиска = 1 Тогда
			Если МетПоиска = 1 Тогда
				ТекстПредупреждения = "Найден единственный предмет снабжения по точному соответствию обозначения.";
			ИначеЕсли МетПоиска = 2 Тогда
				ТекстПредупреждения = "Найден единственный предмет снабжения по подобному обозначению.";
			ИначеЕсли МетПоиска = 3 Тогда
				ТекстПредупреждения = "Найден единственный предмет снабжения по точному соответствию наименования.";
			КонецЕсли;
			
		ИначеЕсли РезПоиска = 2 Тогда
			Если МетПоиска = 1 Тогда
				ТекстПредупреждения = "Найдено несколько предметов снабжения по точному соответствию обозначения.";
			ИначеЕсли МетПоиска = 2 Тогда
				ТекстПредупреждения = "Найдено несколько предметов снабжения по подобному обозначению.";
			ИначеЕсли МетПоиска = 3 Тогда
				ТекстПредупреждения = "Найдено несколько предметов снабжения по точному соответствию наименования.";
			КонецЕсли;
			
		КонецЕсли;
		
		Если ЗначениеЗаполнено(ТекстПредупреждения) Тогда
			ПоказатьПредупреждение(,ТекстПредупреждения);
		КонецЕсли;
		
	КонецЕсли; // Если ТекДанные <> Неопределено Тогда

КонецПроцедуры // ПолучитьОписаниеИПоказатьПользователю

#КонецОбласти

#Область CallBackМетоды

&НаКлиенте
Процедура ПослеОткрытияОбъекта(ДополнительныеПараметры) Экспорт

	//не удалять
	
КонецПроцедуры	//ПослеОткрытияОбъекта

&НаКлиенте
Процедура ПослеВыбораФайла(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт 
	
	Если ВыбранныеФайлы = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ИмяФайла 	= ВыбранныеФайлы[0];
	ДанныеExcel = ПрочитатьExcel(ИмяФайла);
	
	ЗаполнитьНачальныеПараметрыПоискаВДокументе();
	
КонецПроцедуры // ПослеВыбораФайла

&НаКлиенте
Процедура ПослеВопросаОЗакрытии(КодОтвета, ДополнительныеПараметры) Экспорт
	
	Если КодОтвета = КодВозвратаДиалога.Да Тогда
		Закрыть();
	КонецЕсли; // Если КодОтвета = КодВозвратаДиалога.Да Тогда
	
КонецПроцедуры // ПослеВопросаОЗакрытии

#КонецОбласти

#Область Проверки

&НаКлиенте
Функция ПроверитьЗаполнениеНастроек()
	
	Результат = Истина;
	
	Если НомерПервойСтроки = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан номер первой строки",, "НомерПервойСтроки");
		Результат = Ложь;
	КонецЕсли; 
	
	Если НомерПоследнейСтроки = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан номер последней строки",, "НомерПоследнейСтроки");
		Результат = Ложь;
	КонецЕсли; 
	
	Если НомерПоследнейСтроки < НомерПервойСтроки Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Номер последней строки должен быть больше номера первой строки",, "НомерПоследнейСтроки");
		Результат = Ложь;
	КонецЕсли; 
	
	Если КолонкаКодПС = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка Обозначение",, "КолонкаКодПС");
		Результат = Ложь;
	КонецЕсли; 
	
	Если КолонкаНаименованиеПС = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка Наименование",, "КолонкаНаименованиеПС");
		Результат = Ложь;
	КонецЕсли; 
	
	Если КолонкаКоличество = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка Количество",, "КолонкаКоличество");
		Результат = Ложь;
	КонецЕсли; 
	
	Если КолонкаЦена = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указана колонка Цена",, "КолонкаЦена");
		Результат = Ложь;
	КонецЕсли; 
	
	Возврат Результат;
	
КонецФункции // ПроверитьЗаполнениеНастроек

&НаКлиенте
Функция ПроверитьЗаполнениеНастроекСозданияДокументов()
	
	Результат = Истина;
	
	Если ТаблицаДанных.Количество() = 0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Таблица предметов снабжения пуста, загрузка остановлена",, "ТаблицаДанных");
		Результат = Ложь;
	КонецЕсли; // Если ТаблицаДанных.Количество() = 0 Тогда
	
	Для Каждого тдСтр Из ТаблицаДанных Цикл
		
		Если Не ЗначениеЗаполнено(тдСтр.ПредметСнабжения) Тогда
			НомСтроки = ТаблицаДанных.Индекс(тдСтр) + 1;
			текстСообщения = "В строке №" + НомСтроки + " не заполнен предмет снабжения";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(текстСообщения,, "ТаблицаДанных["+(НомСтроки-1)+"].ПредметСнабжения");
			Результат = Ложь;
		КонецЕсли;
		
		Если Не ЗначениеЗаполнено(тдСтр.Цена) Тогда
			НомСтроки = ТаблицаДанных.Индекс(тдСтр) + 1;
			текстСообщения = "В строке №" + НомСтроки + " не заполнена цена";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(текстСообщения,, "ТаблицаДанных["+(НомСтроки-1)+"].Цена");
			Результат = Ложь;
		КонецЕсли;
		
	КонецЦикла;
	
	РезПроверки = ПроверкаНаДубли();
	
	Если РезПроверки.Свойство("Ошибка") Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(РезПроверки.Ошибка);
		ОбновитьКнопкуОтборДублей(РезПроверки.дублей);
		Результат = Ложь;
	КонецЕсли;
		
	Возврат Результат;
	
КонецФункции // ПроверитьЗаполнениеНастроекСозданияДокументов

&НаСервере
Функция ПроверкаНаДубли()

	Ответ = Новый Структура();
	
	//ТЗБезДудлей = ПолучитьТаблицуБезДублей();
	
	ТзДублей = ПолучитьТаблицуДублирующизсяПС();
	
	//Если ТаблицаДанных.Количество() <> ТЗБезДудлей.Количество() Тогда
	Если ТзДублей.Количество() > 0 Тогда
		
		//ТаблицаДанных.Загрузить(ТЗБезДудлей);	
		
		НайденныеДубли = ТаблицаДанных.НайтиСтроки(Новый Структура("ЕстьДубли", Истина));
		Для Каждого нДубль Из НайденныеДубли Цикл
			Если ТзДублей.Найти(нДубль.ПредметСнабжения) = Неопределено Тогда
				нДубль.ЕстьДубли = Ложь;
			КонецЕсли;
		КонецЦикла;
		
		ТекстОшибки = "В таблице предметов снабжения найдены дубли. 
					|Удалите лишние строки и повторите создание контракта."; 
		
		Ответ.Вставить("Ошибка", ТекстОшибки); 
		
		Для Каждого пСдубль Из ТзДублей Цикл
			НайденныеПредметы = ТаблицаДанных.НайтиСтроки(Новый Структура("ПредметСнабжения", пСдубль.ПредметСнабжения));
			Для Каждого нСтрока Из НайденныеПредметы Цикл
				нСтрока.ЕстьДубли = истина;
			КонецЦикла;
			
		КонецЦикла;
	Иначе
		НайденныеДубли = ТаблицаДанных.НайтиСтроки(Новый Структура("ЕстьДубли", Истина));
		Для Каждого нДубль Из НайденныеДубли Цикл
			нДубль.ЕстьДубли = Ложь;
		КонецЦикла;
		
	КонецЕсли;
	
	Ответ.Вставить("Дублей", ТзДублей.Количество());
	
	Возврат Ответ;
	
КонецФункции // ПроверкаНаДубли()

#КонецОбласти

#Область ПолучениеДанных

&НаСервере
Функция ПолучитьЗначениеРеквизита(Ссылка, ИмяРеквизита)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Ссылка, ИмяРеквизита);
КонецФункции // ПолучитьЗначениеРеквизита

&НаСервере
Процедура ЗаполнитьПредметыСнабжения()
	
	УстановитьПривилегированныйРежим(Истина);
	
	стрДопСимволов = Новый Структура;
	стрДопСимволов.Вставить("Цифры", 				Истина);
	стрДопСимволов.Вставить("ЛатиницаЗаглавные", 	Истина);
	стрДопСимволов.Вставить("ЛатиницаПрописные", 	Истина);
	стрДопСимволов.Вставить("Кириллица", 			Истина);
	
	МаксимумВариантовПС = 10;
	
	Для Каждого СтрокаТаблицы Из ТаблицаДанных Цикл
		
		НайденоПоТочномуОбозначению   = Ложь;
		НайденоПоПодобномуОбозначению = Ложь;
		НайденоПоТочномуНаименованию  = Ложь;
		
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
			Продолжить;
		КонецЕсли; // Если ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
		
		ПоискПоНаименованию = Ложь;
		
		Обозначение = СтрокаТаблицы.Обозначение;
		Наименован_ = СтрокаТаблицы.Наименование;
		
		Если ЗначениеЗаполнено(Обозначение) И СтрДлина(Обозначение) > 3 Тогда 
		ИначеЕсли ЗначениеЗаполнено(Наименован_) Тогда 
			ПоискПоНаименованию = Истина;
		ИначеЕсли Не ЗначениеЗаполнено(Обозначение) И Не ЗначениеЗаполнено(Наименован_) Тогда
			Продолжить;
		КонецЕсли; // Если ЗначениеЗаполнено(Обозначение) И СтрДлина(Обозначение) > 3 Тогда 

		НайденныеПС = Новый СписокЗначений();
		
		Если Не ПоискПоНаименованию Тогда
			НайденныеПС = НайтиПСПоТочномуОбозначению(Обозначение);
			//НайтиПСПростымЗапросом(Обозначение, ПоискПоНаименованию, МаксимумВариантовПС, стрДопСимволов, Истина); 
			Если НайденныеПС.Количество() = 0 Тогда
				НайденныеПС = НайтиПСПростымЗапросом(Обозначение, ПоискПоНаименованию, МаксимумВариантовПС, стрДопСимволов);	
				Если НайденныеПС.Количество() > 0 Тогда
					НайденоПоПодобномуОбозначению = Истина;	
				КонецЕсли;
			Иначе
				НайденоПоТочномуОбозначению = Истина;
			КонецЕсли;
			Если НайденныеПС.Количество() = 0 И ЗначениеЗаполнено(Наименован_) Тогда
				НайденныеПС = НайтиПСПоНаименованию(Наименован_);
				//НайтиПСПростымЗапросом(Наименован_, ПоискПоНаименованию, МаксимумВариантовПС, стрДопСимволов); 
				Если НайденныеПС.Количество() > 0 Тогда
					НайденоПоТочномуНаименованию = Истина;	
				КонецЕсли;
			КонецЕсли;
		Иначе
			НайденныеПС = НайтиПСПоНаименованию(Наименован_);
			//НайденныеПС = НайтиПСПростымЗапросом(Наименован_, ПоискПоНаименованию, МаксимумВариантовПС, стрДопСимволов); 
			Если НайденныеПС.Количество() > 0 Тогда
				НайденоПоТочномуНаименованию = Истина;	
			КонецЕсли;
		КонецЕсли;
		
		Если НайденныеПС.Количество() = 0 Тогда
			СтрокаТаблицы.РезультатовПоиска = 0;	
			
		ИначеЕсли НайденныеПС.Количество() = 1 Тогда
			СтрокаТаблицы.ПредметСнабжения = НайденныеПС[0].Значение;	
			СтрокаТаблицы.РезультатовПоиска = 1;	
			
			Если НайденоПоТочномуОбозначению Тогда
				СтрокаТаблицы.МетодПоиска = 1;
			ИначеЕсли НайденоПоПодобномуОбозначению Тогда 
				СтрокаТаблицы.МетодПоиска = 2;
			ИначеЕсли НайденоПоТочномуНаименованию Тогда 
				СтрокаТаблицы.МетодПоиска = 3;
			КонецЕсли;
			
		Иначе
			СтрокаТаблицы.РезультатовПоиска = 2;	
			ПоместитьСтрокиВТаблицуБыстрогоПоиска(НайденныеПС, СтрокаТаблицы.ИДСтроки, ПоискПоНаименованию);
			
			Если НайденоПоТочномуОбозначению Тогда
				СтрокаТаблицы.МетодПоиска = 1;
			ИначеЕсли НайденоПоПодобномуОбозначению Тогда 
				СтрокаТаблицы.МетодПоиска = 2;
			ИначеЕсли НайденоПоТочномуНаименованию Тогда 
				СтрокаТаблицы.МетодПоиска = 3;
			КонецЕсли;
			
		КонецЕсли;
		
		// Заполним вспомогатиельные реквизиты
		Если ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
			СтрокаТаблицы.ОбозначениеПС 	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТаблицы.ПредметСнабжения, "Обозначение");
			СтрокаТаблицы.ЕдиницаИзмерения 	= ОбщегоНазначения.ЗначениеРеквизитаОбъекта(СтрокаТаблицы.ПредметСнабжения, "ЕдиницаИзмерения");
		КонецЕсли; // Если ЗначениеЗаполнено(СтрокаТаблицы.ПредметСнабжения) Тогда
		
	КонецЦикла; 
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецПроцедуры // ЗаполнитьПредметыСнабжения

&НаСервере
Функция ПолучитьСписокАвтоподбора(ИдСтроки)
	
	Ответ = Новый СписокЗначений;
	
	НайденныеСтроки = ТаблицаБыстрогоПоиска.НайтиСтроки(Новый Структура("ИдСтроки", ИдСтроки));
	Для Каждого Строка Из НайденныеСтроки Цикл
		Ответ.Добавить(Строка.ПредметСнабжения, СформироватьСтрокуАвтоподбора(Строка, Строка.ПоискПоНаименованию));
	КонецЦикла;
	Ответ.СортироватьПоПредставлению();
	
	Возврат Ответ;
	
КонецФункции // ПолучитьСписокАвтоподбора()

&НаСервере
Функция НайтиПСПростымЗапросом(Обозначение, ПоНаименованию = Ложь, МаксРезультатов = 10, стрДопСимволов = Неопределено, ПоТочномуОбозначению = Ложь) Экспорт
	
	Ответ 	= Новый СписокЗначений;
	Запрос 	= Новый Запрос;
	
	#Область ТекстЗапроса
	ТекстЗапроса = "ВЫБРАТЬ
	|	КаталогПредметовСнабжения.Ссылка КАК Ссылка
	|ПОМЕСТИТЬ ВТ_Источник
	|ИЗ
	|	Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	|ГДЕ
	|	НЕ КаталогПредметовСнабжения.ПометкаУдаления
	|	И &парКаталогПредметовСнабженияИмя ПОДОБНО &Обозначение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КаталогПредметовСнабжения.Ссылка
	|ИЗ
	|	Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	|ГДЕ
	|	НЕ КаталогПредметовСнабжения.ПометкаУдаления
	|	И КаталогПредметовСнабжения.ОбозначениеТранслитированное ПОДОБНО &Обозначение
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	КодыINCAT.ПредметСнабжения
	|ИЗ
	|	РегистрСведений.КодыINCAT КАК КодыINCAT
	|ГДЕ
	|	КодыINCAT.КодINCAT ПОДОБНО &Обозначение
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ &МаксРезультатов
	|	ВТ_Источник.Ссылка КАК Ссылка,
	|	ВТ_Источник.Ссылка.Обозначение КАК Обозначение
	|ИЗ
	|	ВТ_Источник КАК ВТ_Источник";
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&парКаталогПредметовСнабженияИмя", 
								?(ПоНаименованию, "КаталогПредметовСнабжения.Наименование", "КаталогПредметовСнабжения.Обозначение"));
								
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&МаксРезультатов", МаксРезультатов);
	#КонецОбласти
	
	Запрос.Текст = ТекстЗапроса;
	
	
	Если ПоНаименованию Тогда 
		Запрос.УстановитьПараметр("Обозначение", Обозначение);
	ИначеЕсли ПоТочномуОбозначению Тогда
		Запрос.УстановитьПараметр("Обозначение", Обозначение);
	Иначе
		Запрос.УстановитьПараметр("Обозначение", "%" + ПодготовитьОбозначениеКПоиску(Обозначение, стрДопСимволов) + "%");
	КонецЕсли;
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Ответ.Добавить(Выборка.Ссылка, "" + Выборка.Обозначение + " - " + Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции // НайтиПСПростымЗапросом()

&НаСервере
Функция НайтиПСПоТочномуОбозначению(Обозначение, МаксРезультатов = 10) Экспорт
	
	Ответ 	= Новый СписокЗначений;
	Запрос 	= Новый Запрос;
	
	#Область ТекстЗапроса
	ТекстЗапроса = "ВЫБРАТЬ
	               |	КаталогПредметовСнабжения.Ссылка КАК Ссылка
	               |ПОМЕСТИТЬ ВТ_Источник
	               |ИЗ
	               |	Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	               |ГДЕ
	               |	НЕ КаталогПредметовСнабжения.ПометкаУдаления
	               |	И КаталогПредметовСнабжения.Обозначение = &Обозначение
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	КаталогПредметовСнабжения.Ссылка
	               |ИЗ
	               |	Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	               |ГДЕ
	               |	НЕ КаталогПредметовСнабжения.ПометкаУдаления
	               |	И КаталогПредметовСнабжения.ОбозначениеТранслитированное = &Обозначение
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	КодыINCAT.ПредметСнабжения
	               |ИЗ
	               |	РегистрСведений.КодыINCAT КАК КодыINCAT
	               |ГДЕ
	               |	КодыINCAT.КодINCAT = &Обозначение
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ &МаксРезультатов
	               |	ВТ_Источник.Ссылка КАК Ссылка,
	               |	ВТ_Источник.Ссылка.Обозначение КАК Обозначение
	               |ИЗ
	               |	ВТ_Источник КАК ВТ_Источник";
								
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&МаксРезультатов", МаксРезультатов);
	#КонецОбласти
	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Обозначение", Обозначение);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Ответ.Добавить(Выборка.Ссылка, "" + Выборка.Обозначение + " - " + Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции // НайтиПСПростымЗапросом()

&НаСервере
Функция НайтиПСПоНаименованию(ЗначПоиска, МаксРезультатов = 10) 
	
	Ответ 	= Новый СписокЗначений;
	Запрос 	= Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ ПЕРВЫЕ &МаксРезультатов 
	|	КаталогПредметовСнабжения.Ссылка КАК Ссылка,
	|	КаталогПредметовСнабжения.Обозначение КАК Обозначение
	|ИЗ
	|	Справочник.КаталогПредметовСнабжения КАК КаталогПредметовСнабжения
	|ГДЕ
	|	НЕ КаталогПредметовСнабжения.ПометкаУдаления
	|	И КаталогПредметовСнабжения.Наименование = &Наименование";
	
	
	ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "&МаксРезультатов", МаксРезультатов);	
	Запрос.Текст = ТекстЗапроса;
	Запрос.УстановитьПараметр("Наименование", ЗначПоиска);
	
	Результат = Запрос.Выполнить();
	
	Если Не Результат.Пустой() Тогда
		
		Выборка = Результат.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			
			Ответ.Добавить(Выборка.Ссылка, "" + Выборка.Обозначение + " - " + Выборка.Ссылка);
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции // НайтиПСПростымЗапросом()

&НаСервере
Функция МассивДопустимыхСимволовПростогоПоиска(парОтбора = Неопределено)
	
	Результат = Новый Массив;
	
	Если парОтбора = Неопределено Или парОтбора.Свойство("Пробел") Тогда
		ДобавитьСимволыВМассив(32, 	 32, 	Результат); // Пробел
	КонецЕсли;
	Если парОтбора = Неопределено Или парОтбора.Свойство("Цифры") Тогда	
		ДобавитьСимволыВМассив(48, 	 57, 	Результат); // Цифры
	КонецЕсли;
	Если парОтбора = Неопределено Или парОтбора.Свойство("ЛатиницаЗаглавные") Тогда
		ДобавитьСимволыВМассив(65, 	 90, 	Результат); // Латиница заглавные
	КонецЕсли;
	Если парОтбора = Неопределено Или парОтбора.Свойство("ЛатиницаПрописные") Тогда
		ДобавитьСимволыВМассив(97, 	 122,  	Результат); // Латиница прописные
	КонецЕсли;
	Если парОтбора = Неопределено Или парОтбора.Свойство("Кириллица") Тогда
		ДобавитьСимволыВМассив(1040, 1103, 	Результат); // Кирилица
		ДобавитьСимволыВМассив(1025, 1025, 	Результат); // Ё
		ДобавитьСимволыВМассив(1105, 1105, 	Результат); // ё
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции	//МассивДопустимыхСимволовПростогоПоиска

&НаСервере
Процедура ДобавитьСимволыВМассив(НижняяГраница, ВерхняяГраница, МассивПолучатель)
	
	Для Сч = НижняяГраница По ВерхняяГраница Цикл
		МассивПолучатель.Добавить(Сч);
	КонецЦикла; 
	
КонецПроцедуры

&НаСервере
Функция ПодготовитьОбозначениеКПоиску(Знач Обозначение, стрДопустимыхСимволов = Неопределено)
	
	Пока СтрНайти(Обозначение, "  ") > 0 Цикл
		Обозначение = СтрЗаменить(Обозначение, "  ", " ");
		Обозначение = СокрЛП(Обозначение);
	КонецЦикла;
	Результат 	= "";
	
	ДопустимыеСимволы = МассивДопустимыхСимволовПростогоПоиска(стрДопустимыхСимволов);
	Для Сч = 1 По СтрДлина(Обозначение) Цикл
		Символ = Сред(Обозначение, Сч, 1);
		Если ДопустимыеСимволы.Найти(КодСимвола(Символ, 1)) = Неопределено Тогда
			Результат = Результат + "_";
		Иначе
			Результат = Результат + Символ;
		КонецЕсли;
	КонецЦикла;
	
	Возврат Результат;
КонецФункции // ПодготовитьОбозначениеКПоиску

#КонецОбласти

#Область ЧтениеExcel

&НаКлиенте
Функция ПрочитатьExcel(ИмяФайла)
	
	Расширение = ПолучитьРасширениеФайла(ИмяФайла);
	
	ДвоичныеДанные = Новый ДвоичныеДанные(ИмяФайла);
	
	АдресВС = ПоместитьВоВременноеХранилище(ДвоичныеДанные);
	
	Возврат ПрочитатьТабличныйДокументНаСервере(АдресВС, Расширение);
	
КонецФункции // ПрочитатьExcel

&НаКлиенте
Функция ЗаполнитьНачальныеПараметрыПоискаВДокументе()
	
	НомерПоследнейСтроки = ДанныеExcel.ВысотаТаблицы;
	
КонецФункции // ЗаполнитьНачальныеПараметрыПоискаВДокументе

#КонецОбласти

#Область ОбработкаТабличногоДокумента

&НаСервере
Функция ПолучитьЗначение(НомерСтроки, НомерКолонки, ЧисловоеЗначение = Ложь)
	
	Попытка
		ИмяОбласти 		= "R" + Формат(НомерСтроки, "ЧГ=") +"C" + Формат(НомерКолонки);
		СтрокаДанных 	= ДанныеExcel.Область(ИмяОбласти).Текст;
		СтрокаДанных 	= СокрЛП(СтрокаДанных);
		Если ЧисловоеЗначение Тогда
			Если СтрНайти(СтрокаДанных, ".") > 0 И СтрНайти(СтрокаДанных, ",") > 0 Тогда
				СтрокаДанных = СтрЗаменить(СтрокаДанных, ",", "");
			КонецЕсли;
			Результат 	= СтроковыеФункцииКлиентСервер.СтрокаВЧисло(СтрокаДанных);
		Иначе
			Результат 	= СтрокаДанных;
		КонецЕсли;                                  	
	Исключение
		Результат 		= ?(ЧисловоеЗначение, -1, "");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("" + ИмяОбласти + ": не удалось получить значение. " + ОписаниеОшибки());
	КонецПопытки;
	
	Возврат Результат;
	
КонецФункции // ПолучитьЗначение

#КонецОбласти

#Область СохранениеФайла

&НаКлиенте
Асинх Процедура СохранитьФайлИсточник()
	
	ПолноеИмяФайла = Ждать КаталогВременныхФайловАсинх() + "Файл источник.xlsx";
	Ждать ДанныеExcel.ЗаписатьАсинх(ПолноеИмяФайла, ТипФайлаТабличногоДокумента.XLSX);
	
	ДопПараметры = Новый Структура("ПолноеИмяФайлаЗагрузка", ПолноеИмяФайла);
	ПрисоединенныеФайлыКлиент.ДобавитьФайлы(ДокументКонтракт, ЭтаФорма.УникальныйИдентификатор, "Excel 97|*.xls|Excel 2007|*.xlsx|", ДопПараметры);
	
	УдалитьФайлыАсинх(ПолноеИмяФайла);
	
КонецПроцедуры // СохранитьФайлИсточник 

#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ КОМАНД

#Область Команды

&НаКлиенте
Процедура КомандаЗаполнитьТаблицуДанных(Команда)
	
	СнятьУстановитьОтборДублей(Истина);
	УстановитьВидимостьПоУмолчанию();
	Если Не ПроверитьЗаполнениеНастроек() Тогда
		Возврат;
	КонецЕсли; // Если Не ПроверитьЗаполнениеНастроек() Тогда

	ЗаполнениеТаблицыДанных();
	
	РезПроверкаДублей = ПроверкаНаДубли(); 
	ОбновитьКнопкуОтборДублей(РезПроверкаДублей.Дублей);
	
КонецПроцедуры // КомандаЗаполнитьТаблицуДанных

&НаКлиенте
Процедура КомандаВыбратьФайл(Команда)
	ДиалогПриВыбореФайла();
КонецПроцедуры	//КомандаВыбратьФайл

&НаКлиенте
Процедура КомандаОтборДублей(Команда)
	
	СнятьУстановитьОтборДублей();
		
КонецПроцедуры	//КомандаОтборДублей

&НаКлиенте
Процедура КомандаПолучитьОписание(Команда)
	ПолучитьОписаниеИПоказатьПользователю()
КонецПроцедуры

&НаКлиенте
Процедура Загрузить(Команда)
	
	Если Не ПроверитьЗаполнениеНастроекСозданияДокументов() Тогда
		Возврат;
	КонецЕсли; // Если Не ПроверитьЗаполнениеНастроекСозданияДокументов() Тогда
	
	АдресВременногоХранилища = ПоместитьЗагружаемыеДанныеВоВременноеХранилище();
	Оповестить("ЗагрузитьПредметыСнабженияКонтракт", АдресВременногоХранилища);
	
	Если СохранятьФайлИсточник Тогда
		СохранитьФайлИсточник();
	КонецЕсли; // Если СохранятьФайлИсточник Тогда
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеВопросаОЗакрытии", ЭтаФорма);
	ПоказатьВопрос(ОписаниеОповещения, "Предметы снабжения загружены, закрыть обработку?", РежимДиалогаВопрос.ДаНет, 30, КодВозвратаДиалога.Нет,,КодВозвратаДиалога.Нет);
	
КонецПроцедуры // Загрузить

&НаСервере
Функция ПоместитьЗагружаемыеДанныеВоВременноеХранилище()
	Возврат ПоместитьВоВременноеХранилище(ТаблицаДанных.Выгрузить());
КонецФункции // ПоместитьЗагружаемыеДанныеВоВременноеХранилище

#КонецОбласти

///////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

#Область СобытияФормыИЭлементов

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Параметры.Свойство("ДокументКонтракт", ДокументКонтракт);
	УстановитьПараметрыПоУмолчанию();
КонецПроцедуры // ПриСозданииНаСервере

&НаКлиенте
Процедура ИмяФайлаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	ДиалогПриВыбореФайла();
КонецПроцедуры // ИмяФайлаНачалоВыбора

&НаКлиенте
Процедура ДанныеExcelПриИзменении(Элемент)
	
	ЗаполнитьНачальныеПараметрыПоискаВДокументе();
	
КонецПроцедуры	//ДанныеExcelПриИзменении

#КонецОбласти

#Область СобытияТаблицыДанных

&НаКлиенте
Процедура ТаблицаДанныхПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа, Параметр)
	Отказ = Истина;
КонецПроцедуры // ТаблицаДанныхПередНачаломДобавления

&НаКлиенте
Процедура ТаблицаДанныхПередУдалением(Элемент, Отказ)
	Отказ = Истина;
КонецПроцедуры // ТаблицаДанныхПередУдалением

&НаКлиенте
Процедура ТаблицаДанныхПредметСнабженияПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицаДанных.ТекущиеДанные;
	Если ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;  // Если ТекущаяСтрока = Неопределено Тогда
	
	ТекущаяСтрока.ОбозначениеПС    = ПолучитьЗначениеРеквизита(ТекущаяСтрока.ПредметСнабжения, "Обозначение");
	ТекущаяСтрока.ЕдиницаИзмерения = ПолучитьЗначениеРеквизита(ТекущаяСтрока.ПредметСнабжения, "ЕдиницаИзмерения");
	
	ТекущаяСтрока.МетодПоиска      = 0;
	
	РезПроверкиДублей = ПроверкаНаДубли();
	ОбновитьКнопкуОтборДублей(РезПроверкиДублей.Дублей);
	
КонецПроцедуры // ТаблицаДанныхПредметСнабженияПриИзменении

&НаКлиенте
Процедура ТаблицаДанныхПредметСнабженияАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	Если Ожидание = 0 Тогда
		ТекущаяСтрока = Элементы.ТаблицаДанных.ТекущиеДанные;
		Если ТекущаяСтрока.РезультатовПоиска = 2 Тогда
			СписокВыбора = ПолучитьСписокАвтоподбора(ТекущаяСтрока.ИдСтроки); 
			Если СписокВыбора.Количество() > 0 Тогда
				СтандартнаяОбработка 	= Ложь;
				ДанныеВыбора 			= СписокВыбора;		
			КонецЕсли; // Если СписокВыбора.Количество() > 0 Тогда
		КонецЕсли; // Если ТекущаяСтрока.РезультатовПоиска = 2 Тогда
	КонецЕсли; // Если Ожидание = 0 Тогда
	
КонецПроцедуры // ТаблицаДанныхПредметСнабженияАвтоПодбор

&НаКлиенте
Процедура УдалитьСтроку(Команда)
	УдалитьВыделеннуюСтроку();
КонецПроцедуры	//УдалитьСтроку


#КонецОбласти
