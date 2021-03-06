
///////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = "Заявка № " + Данные.НомерЗаказчика + " от " + Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
	
КонецПроцедуры	//ОбработкаПолученияПредставления

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("НомерЗаказчика");
	Поля.Добавить("Дата");
	
КонецПроцедуры	//ОбработкаПолученияПолейПредставления

#Область ПечатьЗаявки
Функция ПолучитьСтрокуПроектов(ПредметИсточник, Проекты)
	
	Ответ = "";
	
	НайденныеСтроки = Проекты.НайтиСтроки(Новый Структура("ПредметСнабжения",ПредметИсточник)); 
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		Для Каждого стрПроект Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(Ответ) Тогда
				Ответ = Ответ + ", ";
			КонецЕсли;
			
			Ответ = Ответ + стрПроект.Проект;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;

КонецФункции // ПолучитьСтрокуПроектов()

Функция ПолучитьСтрокуАналог(ПредметИсточник, Аналоги)
	
	Ответ = "";
	
	НайденныеСтроки = Аналоги.НайтиСтроки(Новый Структура("ПредметСнабжения",ПредметИсточник)); 
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		Для Каждого нСтрока Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(Ответ) Тогда
				Ответ = Ответ + ", ";
			КонецЕсли;
			
			Ответ = Ответ + нСтрока.АналогНаименование;
			
			Если ЗначениеЗаполнено(нСтрока.АналогОбозначение) Тогда
				Ответ = Ответ + нСтрока.АналогОбозначение;
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции	//ПолучитьСтрокуАналог

Функция ПолучитьСтрокуПоставщик(ПредметИсточник, Поставщик)
	
	Ответ = "";
	
	НайденныеСтроки = Поставщик.НайтиСтроки(Новый Структура("ПредметСнабжения",ПредметИсточник)); 
	
	Если НайденныеСтроки.Количество() > 0 Тогда
		
		Для Каждого нСтрока Из НайденныеСтроки Цикл
			
			Если ЗначениеЗаполнено(Ответ) Тогда
				Ответ = Ответ + ";" + Символы.ПС;
			КонецЕсли;
			
			Ответ = Ответ + нСтрока.Контрагент;
			
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Ответ;
	
КонецФункции	//ПолучитьСтрокуАналог

Функция ВыполнитьПакетныйЗапросПечати(Заявка)
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	#Область ТекстЗапроса
		"ВЫБРАТЬ
		|	ЗаявкаСпецификация.ПредметСнабжения КАК ПредметСнабжения,
		|	ЗаявкаСпецификация.НаименованиеПредметаСнабженияЗаказчика КАК НаименованиеПСИзЗаявки,
		|	ВЫБОР
		|		КОГДА ЗаявкаСпецификация.ПредметСнабжения = ЗНАЧЕНИЕ(Справочник.КаталогПредметовСнабжения.ПустаяСсылка)
		|			ТОГДА ЛОЖЬ
		|		ИНАЧЕ ИСТИНА
		|	КОНЕЦ КАК ЗаполнятьДанные,
		|	ЗаявкаСпецификация.НомерСтроки КАК НомерСтроки
		|ПОМЕСТИТЬ ВТ_ПредметыСнабжения
		|ИЗ
		|	Документ.Заявка.Спецификация КАК ЗаявкаСпецификация
		|ГДЕ
		|	ЗаявкаСпецификация.Ссылка = &Заявка
		|
		|ИНДЕКСИРОВАТЬ ПО
		|	ПредметСнабжения
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	Заказы.Владелец КАК Проект,
		|	ВТ_ПредметыСнабжения.ПредметСнабжения КАК ПредметСнабжения
		|ИЗ
		|	ВТ_ПредметыСнабжения КАК ВТ_ПредметыСнабжения
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП КАК СтруктураЗаказаПоКомплектующимИзделиямИЗИП
		|			ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Заказы КАК Заказы
		|			ПО СтруктураЗаказаПоКомплектующимИзделиямИЗИП.Владелец = Заказы.Ссылка
		|		ПО ВТ_ПредметыСнабжения.ПредметСнабжения = СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ПредметСнабжения
		|ГДЕ
		|	Заказы.Заказчик = &Флот
		|	И ВТ_ПредметыСнабжения.ЗаполнятьДанные
		|	И Заказы.Владелец <> &Неопределено
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КаталогПредметовСнабженияАналоги.Ссылка КАК ПредметСнабжения,
		|	КаталогПредметовСнабженияАналоги.Аналог.Наименование КАК АналогНаименование,
		|	КаталогПредметовСнабженияАналоги.Аналог.Обозначение КАК АналогОбозначение
		|ИЗ
		|	ВТ_ПредметыСнабжения КАК ВТ_ПредметыСнабжения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КаталогПредметовСнабжения.Аналоги КАК КаталогПредметовСнабженияАналоги
		|		ПО ВТ_ПредметыСнабжения.ПредметСнабжения = КаталогПредметовСнабженияАналоги.Ссылка
		|			И (ВТ_ПредметыСнабжения.ЗаполнятьДанные)
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗЛИЧНЫЕ
		|	КаталогПредметовСнабженияИзготовителиИПоставщики.Ссылка КАК ПредметСнабжения,
		|	КаталогПредметовСнабженияИзготовителиИПоставщики.Контрагент КАК Контрагент
		|ИЗ
		|	ВТ_ПредметыСнабжения КАК ВТ_ПредметыСнабжения
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.КаталогПредметовСнабжения.ИзготовителиИПоставщики КАК КаталогПредметовСнабженияИзготовителиИПоставщики
		|		ПО ВТ_ПредметыСнабжения.ПредметСнабжения = КаталогПредметовСнабженияИзготовителиИПоставщики.Ссылка
		|ГДЕ
		|	(КаталогПредметовСнабженияИзготовителиИПоставщики.Поставщик
		|			ИЛИ КаталогПредметовСнабженияИзготовителиИПоставщики.Изготовитель)
		|	И ВТ_ПредметыСнабжения.ЗаполнятьДанные
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныПредметовСнабженияСрезПоследних.Контрагент КАК Контрагент,
		|	ЦеныПредметовСнабженияСрезПоследних.Цена КАК Цена,
		|	ЦеныПредметовСнабженияСрезПоследних.Валюта КАК Валюта,
		|	ЦеныПредметовСнабженияСрезПоследних.Период КАК Период,
		|	ЦеныПредметовСнабженияСрезПоследних.ПредметСнабжения КАК ПредметСнабжения
		|ИЗ
		|	РегистрСведений.ЦеныПредметовСнабжения.СрезПоследних(
		|			,
		|			ПредметСнабжения В
		|					(ВЫБРАТЬ
		|						ВТ_ПредметыСнабжения.ПредметСнабжения
		|					ИЗ
		|						ВТ_ПредметыСнабжения
		|					ГДЕ
		|						ВТ_ПредметыСнабжения.ЗаполнятьДанные)
		|				И ТипЦены = ЗНАЧЕНИЕ(Перечисление.ТипыЦен.Внутренняя)
		|				И Регистратор.Тип = ЗНАЧЕНИЕ(Перечисление.ТипыКонтрактов.КоммерческоеПредложение)) КАК ЦеныПредметовСнабженияСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ЦеныСрезПоследних.ПредметСнабжения КАК ПредметСнабжения,
		|	ЦеныСрезПоследних.КлючАналитики.Продавец КАК КлючАналитикиПродавец,
		|	ЦеныСрезПоследних.Цена КАК Цена,
		|	ЦеныСрезПоследних.Валюта КАК Валюта,
		|	ЦеныСрезПоследних.Период КАК Период
		|ИЗ
		|	РегистрСведений.Цены.СрезПоследних(
		|			,
		|			ПредметСнабжения В
		|					(ВЫБРАТЬ
		|						ВТ_ПредметыСнабжения.ПредметСнабжения
		|					ИЗ
		|						ВТ_ПредметыСнабжения
		|					ГДЕ
		|						ВТ_ПредметыСнабжения.ЗаполнятьДанные)
		|				И ВидЦены = ЗНАЧЕНИЕ(Справочник.ВидыЦен.Конкурентная)
		|				И Цена > 0) КАК ЦеныСрезПоследних
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	ВЫБОР
		|		КОГДА ВТ_ПредметыСнабжения.ЗаполнятьДанные
		|			ТОГДА ВТ_ПредметыСнабжения.ПредметСнабжения
		|		ИНАЧЕ ВТ_ПредметыСнабжения.НаименованиеПСИзЗаявки
		|	КОНЕЦ КАК НаименованиеПС,
		|	ВТ_ПредметыСнабжения.ЗаполнятьДанные КАК ЗаполнятьДанные,
		|	ВТ_ПредметыСнабжения.НомерСтроки КАК НомерСтроки,
		|	ВТ_ПредметыСнабжения.ПредметСнабжения.Обозначение КАК ОбозначениеПС,
		|	ВТ_ПредметыСнабжения.ПредметСнабжения.ДокументНаПоставку КАК ДокументПоставки
		|ИЗ
		|	ВТ_ПредметыСнабжения КАК ВТ_ПредметыСнабжения
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
	#КонецОбласти		
	Запрос.УстановитьПараметр("Заявка", 		Заявка);
	Запрос.УстановитьПараметр("Флот", 			Заявка.ЗапросТКПRFP.Заказчик.ВМС);
	Запрос.УстановитьПараметр("Неопределено", 	Справочники.ПроектыКораблей.НайтиПоНаименованию("Не определено", Истина));
	
	Результ = Запрос.ВыполнитьПакет();
	
	Возврат Результ;
	
КонецФункции //ВыполнитьПакетныйЗапросПечати
#КонецОбласти

///////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПечатьНаСервере(Заявка) Экспорт
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	МакетЗаявка = ПолучитьМакет("Заявка");
	
	ОбластьШапка 			= МакетЗаявка.ПолучитьОбласть("Шапка"); 
	ОбластьСтрокаОсновное 	= МакетЗаявка.ПолучитьОбласть("СтрокаОсновное");
	ОбластьСтрокаАналоги	= МакетЗаявка.ПолучитьОбласть("СтрокаАналоги");
	ОбластьСтрокаПоставщики	= МакетЗаявка.ПолучитьОбласть("СтрокаПоставщики");
	ОбластьСтрокаКП			= МакетЗаявка.ПолучитьОбласть("СтрокаКоммерческоеПредложение");
	ОбластьСтрокаТендер		= МакетЗаявка.ПолучитьОбласть("СтрокаТендер");
	ОбластьПустаяСтрока		= МакетЗаявка.ПолучитьОбласть("ПустаяСтрока");
	ОбластьПустойТендер		= МакетЗаявка.ПолучитьОбласть("ПустойТендер");
	ОбластьИмяЗаявки		= МакетЗаявка.ПолучитьОбласть("ИмяЗаявки");
	
	ТабличныйДокумент.Вывести(ОбластьИмяЗаявки);
	ТабличныйДокумент.Вывести(ОбластьШапка);
		
	Результ = ВыполнитьПакетныйЗапросПечати(Заявка);
	
	Проекты 	= Результ[1].Выгрузить();
	Аналоги 	= Результ[2].Выгрузить();
	Поставщики 	= Результ[3].Выгрузить();
	КП 			= Результ[4].Выгрузить();
	Тендеры 	= Результ[5].Выгрузить();
	ЗаявкаПС	= Результ[6].Выгрузить();
	
	НачалоОсновная 	= 3;
	КонецОсновная	= 3;
	
	Для Каждого стрПС Из ЗаявкаПС Цикл
		
		КоличествоКП 		= 0;
		КоличествоТендеров 	= 0;
		МаксСтрок			= 0;
		НачалоКП			= 0;
		КонецКП				= 0;
		НачалоТренд			= 0;
		КонецТренд			= 0;
		
		ОбластьСтрокаОсновное.Параметры.Заполнить(стрПС);
		
		Если стрПС.ЗаполнятьДанные Тогда 
			СтрокаПроекты 		= ПолучитьСтрокуПроектов(стрПС.НаименованиеПС, Проекты);
			СтрокаАналог 		= ПолучитьСтрокуАналог(стрПС.НаименованиеПС, Аналоги);
			СтрокаПоставщики 	= ПолучитьСтрокуПоставщик(стрПС.НаименованиеПС, Поставщики);
		Иначе
			СтрокаПроекты 		= "";
			СтрокаАналог 		= "";
			СтрокаПоставщики 	= "";
		КонецЕсли;
		
		ОбластьСтрокаОсновное.Параметры.Применяемость 				= СтрокаПроекты;
		ОбластьСтрокаАналоги.Параметры.Аналог 						= СтрокаАналог;
		ОбластьСтрокаПоставщики.Параметры.ПоставщикиИИзготовители 	= СтрокаПоставщики;
		
		ТабличныйДокумент.Вывести(ОбластьСтрокаОсновное);
		ТабличныйДокумент.Присоединить(ОбластьСтрокаАналоги);
		ТабличныйДокумент.Присоединить(ОбластьСтрокаПоставщики);
		
		//объединение для тендеров и комерческих предложений
		Если стрПС.ЗаполнятьДанные Тогда 
			
			НайденныеКП 		= КП.НайтиСтроки(Новый Структура("ПредметСнабжения", стрПС.НаименованиеПС)); 
			КоличествоКП 		= НайденныеКП.Количество();
			
			НайденныеТендеры 	= Тендеры.НайтиСтроки(Новый Структура("ПредметСнабжения", стрПС.НаименованиеПС));
			КоличествоТендеров	= НайденныеТендеры.Количество();
			
			Если КоличествоКП > 0 Или КоличествоТендеров > 0 Тогда
				
				НачалоОсновная 	= ТабличныйДокумент.ВысотаТаблицы;
				КонецОсновная	= НачалоОсновная - 1;
				
				МаксСтрок = Макс(КоличествоКП, КоличествоТендеров);
				
				Для Счет = 0 По МаксСтрок-1 Цикл
					
					Если Счет > 0 Тогда
						ТабличныйДокумент.Вывести(ОбластьПустаяСтрока);
					КонецЕсли;
					
					Если КоличествоКП > Счет Тогда
						ОбластьСтрокаКП.Параметры.Контрагент 	= НайденныеКП[Счет].Контрагент;
						ОбластьСтрокаКП.Параметры.ЦенаИВалюта 	= "" +НайденныеКП[Счет].Цена + " (" + НайденныеКП[Счет].Валюта + ")";
						ОбластьСтрокаКП.Параметры.Дата 			= Формат(НайденныеКП[Счет].Период, "ДФ=dd.MM.yy");
						
						НачалоКП = ТабличныйДокумент.ВысотаТаблицы;
						КонецКП = НачалоКП;
					Иначе
						ОбластьСтрокаКП.Параметры.Контрагент 	= "";
						ОбластьСтрокаКП.Параметры.ЦенаИВалюта 	= "";
						ОбластьСтрокаКП.Параметры.Дата 			= "";
						Если НачалоКП = 0 Тогда
							НачалоКП = ТабличныйДокумент.ВысотаТаблицы;	
						КонецЕсли;
						КонецКП = ТабличныйДокумент.ВысотаТаблицы;
					КонецЕсли;
					Если КоличествоТендеров > Счет Тогда
						ОбластьСтрокаТендер.Параметры.Контрагент 	= НайденныеТендеры[Счет].КлючАналитикиПродавец;
						ОбластьСтрокаТендер.Параметры.ЦенаИВалюта 	= "" +НайденныеТендеры[Счет].Цена + " (" + НайденныеТендеры[Счет].Валюта + ")";
						ОбластьСтрокаТендер.Параметры.Дата 			= Формат(НайденныеТендеры[Счет].Период, "ДФ=dd.MM.yy");
						НачалоТренд = ТабличныйДокумент.ВысотаТаблицы;
						КонецТренд 	= НачалоТренд;
					Иначе
						ОбластьСтрокаТендер.Параметры.Контрагент 	= "";
						ОбластьСтрокаТендер.Параметры.ЦенаИВалюта 	= "";
						ОбластьСтрокаТендер.Параметры.Дата 			= "";
						Если НачалоТренд = 0 Тогда
							НачалоТренд = ТабличныйДокумент.ВысотаТаблицы;
						КонецЕсли;
						КонецТренд = ТабличныйДокумент.ВысотаТаблицы;
					КонецЕсли;
					
					ТабличныйДокумент.Присоединить(ОбластьСтрокаКП);
					ТабличныйДокумент.Присоединить(ОбластьСтрокаТендер);
					
					КонецОсновная = КонецОсновная + 1;
					
				КонецЦикла;
				
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C1:R" + КонецОсновная + "C1").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C2:R" + КонецОсновная + "C2").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C3:R" + КонецОсновная + "C3").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C4:R" + КонецОсновная + "C4").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C5:R" + КонецОсновная + "C5").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C6:R" + КонецОсновная + "C6").Объединить();
				ТабличныйДокумент.Область("R" + НачалоОсновная + "C7:R" + КонецОсновная + "C7").Объединить();
				
				ТабличныйДокумент.Область("R" + НачалоКП + "C8:R" + КонецКП + "C8").Объединить();
				ТабличныйДокумент.Область("R" + НачалоКП + "C9:R" + КонецКП + "C9").Объединить();
				ТабличныйДокумент.Область("R" + НачалоКП + "C10:R" + КонецКП + "C10").Объединить();
				
				ТабличныйДокумент.Область("R" + НачалоТренд + "C11:R" + КонецТренд + "C11").Объединить();
				ТабличныйДокумент.Область("R" + НачалоТренд + "C12:R" + КонецТренд + "C12").Объединить();
				ТабличныйДокумент.Область("R" + НачалоТренд + "C13:R" + КонецТренд + "C13").Объединить();
			Иначе	
				ТабличныйДокумент.Присоединить(ОбластьПустойТендер);
			КонецЕсли;
		Иначе
			ТабличныйДокумент.Присоединить(ОбластьПустойТендер);
		КонецЕсли;
		
	КонецЦикла;
	
	ТабличныйДокумент.ОтображатьСетку = Ложь;
	ТабличныйДокумент.ОтображатьЗаголовки = ложь;
	
	Возврат ТабличныйДокумент;
	
КонецФункции	//ПечатьНаСервере

