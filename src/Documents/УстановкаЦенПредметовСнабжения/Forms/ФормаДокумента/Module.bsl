
//////////////////////////////////////////////////////////////////////////
//	ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиентеНаСервереБезКонтекста
Процедура УстановитьВидимость(Форма)
	
	Если Форма.Объект.ТипЦены = ПредопределенноеЗначение("Перечисление.ТипыЦен.Внешняя") Тогда
	
		Форма.Элементы.Контрагент.Заголовок = "Заказчик";
		
	Иначе
		
		Форма.Элементы.Контрагент.Заголовок = "Поставщик";
		
	КонецЕсли; 
		
КонецПроцедуры


//////////////////////////////////////////////////////////////////////////
//	ОБРАБОТЧИКИ СОБЫТИЙ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Если Параметры.Свойство("ТипЦены", Объект.ТипЦены) Тогда
			
			Элементы.ТипЦены.Видимость = Ложь;	
			
		КонецЕсли; 
		
		Если Параметры.Свойство("ПредметСнабжения", Объект.ПредметСнабжения) Тогда
			
			Элементы.ПредметСнабжения.Доступность = Ложь;
			
		КонецЕсли; 
		
		Если Параметры.Свойство("ЕдиницаИзмерения", Объект.ЕдиницаИзмерения) Тогда 			
			
		КонецЕсли; 

		
		Объект.Ответственный = Пользователи.ТекущийПользователь();
		
	КонецЕсли; 		
	
	УстановитьВидимость(ЭтаФорма);

КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.ТипЦены) Тогда
	
		СтандартнаяОбработка = Ложь;
		
		ПараметрыОткрытия = Новый Структура;
		ПараметрыОткрытия.Вставить("ТекущаяСтрока", Объект.Контрагент);
			
		ИмяСправочника = ?(Объект.ТипЦены = ПредопределенноеЗначение("Перечисление.ТипыЦен.Внутренняя"), "Организации", "ИностранныеЗаказчики");

		ОткрытьФорму("Справочник." + ИмяСправочника + ".ФормаВыбора", ПараметрыОткрытия,,,,, Новый ОписаниеОповещения("КонтрагентНачалоВыбораЗавершить", ЭтотОбъект));
				
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбораЗавершить(ВыбранныйЭлемент, СписокПараметров) Экспорт

	Если ЗначениеЗаполнено(ВыбранныйЭлемент) Тогда
	
		Объект.Контрагент = ВыбранныйЭлемент;	
		
	КонецЕсли;   	
	
КонецПроцедуры // КонтрагентНачалоВыбораЗавершить

&НаКлиенте
Процедура ТипЦеныПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Объект.ТипЦены) И ЗначениеЗаполнено(Объект.Контрагент) Тогда
	
		Если Объект.ТипЦены = ПредопределенноеЗначение("Перечисление.ТипыЦен.Внутренняя") И НЕ ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.Организации") Тогда
		
			Объект.Контрагент = ПредопределенноеЗначение("Справочник.ИностранныеЗаказчики.ПустаяСсылка");	
			
		ИначеЕсли Объект.ТипЦены = ПредопределенноеЗначение("Перечисление.ТипыЦен.Внешняя") И НЕ ТипЗнч(Объект.Контрагент) = Тип("СправочникСсылка.ИностранныеЗаказчики") Тогда
			
			Объект.Контрагент = ПредопределенноеЗначение("Справочник.Организации.ПустаяСсылка");
			
		КонецЕсли; 		
		
	КонецЕсли; 
	
	УстановитьВидимость(ЭтаФорма);
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
		
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Ошибки = Неопределено;

	Если НЕ ЗначениеЗаполнено(Объект.Контрагент) Тогда
		
		ТекстОшибки = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru = 'Поле ""%1"" не заполнено.'"), Элементы.Контрагент.Заголовок);
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Контрагент", ТекстОшибки, Неопределено);
				
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.Цена) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Цена", НСтр("ru = 'Поле ""Цена"" не заполнено.'"), Неопределено);
		
	КонецЕсли;
			
	Если НЕ ЗначениеЗаполнено(Объект.Валюта) Тогда
		
		ОбщегоНазначенияКлиентСервер.ДобавитьОшибкуПользователю(Ошибки, "Объект.Валюта", НСтр("ru = 'Поле ""Валюта"" не заполнено.'"), Неопределено);
		
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.СообщитьОшибкиПользователю(Ошибки, Отказ); 

КонецПроцедуры
