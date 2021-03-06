
//////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Функция ПолучитьМаксимальноеКоличествоПопытокОтправкиПочтовыхСообщений() Экспорт
	
	Результат = 5;
	
	Если ЗначениеЗаполнено(Справочники.Настройки.МаксимальноеКоличествоПопытокОтправкиПочтовыхСообщений.Значение) И
		ТипЗнч(Справочники.Настройки.МаксимальноеКоличествоПопытокОтправкиПочтовыхСообщений.Значение) = Тип("Число") Тогда
		
		Результат = Справочники.Настройки.МаксимальноеКоличествоПопытокОтправкиПочтовыхСообщений.Значение;
		
	КонецЕсли; 	
	
	Возврат Результат;
	
КонецФункции //ПолучитьМаксимальноеКоличествоПопытокОтправкиПочтовыхСообщений

Функция ПолучитьУчетнуюЗаписьДляОтправкиПочтовыхСообщений() Экспорт
	
	Результат = Справочники.УчетныеЗаписиЭлектроннойПочты.СистемнаяУчетнаяЗаписьЭлектроннойПочты;
	
	Если ЗначениеЗаполнено(Справочники.Настройки.УчетнаяЗаписьДляОтправкиПочтовыхСообщений.Значение) И
		ТипЗнч(Справочники.Настройки.УчетнаяЗаписьДляОтправкиПочтовыхСообщений.Значение) = Тип("СправочникСсылка.УчетныеЗаписиЭлектроннойПочты") Тогда
		
		Результат = Справочники.Настройки.УчетнаяЗаписьДляОтправкиПочтовыхСообщений.Значение;
		
	КонецЕсли; 	
	
	Возврат Результат;
	
КонецФункции //ПолучитьУчетнаяЗаписьДляОтправкиПочтовыхСообщений

Функция ПолучитьШаблонСообщенияНаКоммерческоеПредложение() Экспорт
	
	Результат = Справочники.ШаблоныСообщений.ПустаяСсылка();
	
	Если ЗначениеЗаполнено(Справочники.Настройки.ШаблонСообщенияНаКоммерческоеПредложение.Значение) И
		ТипЗнч(Справочники.Настройки.ШаблонСообщенияНаКоммерческоеПредложение.Значение) = Тип("СправочникСсылка.ШаблоныСообщений") Тогда
		
		Результат = Справочники.Настройки.ШаблонСообщенияНаКоммерческоеПредложение.Значение;
		
	КонецЕсли; 	
	
	Возврат Результат;
	
КонецФункции //ПолучитьУчетнаяЗаписьДляОтправкиПочтовыхСообщений

Функция ПолучитьМаксимальноеКоличествоПопытокПриАктуализацииСтруктурыЗаказов() Экспорт
	
	Результат = 5;
	
	Если ЗначениеЗаполнено(Справочники.Настройки.МаксимальноеКоличествоПопытокПриАктуализацииСтруктурыЗаказов.Значение) И
		ТипЗнч(Справочники.Настройки.МаксимальноеКоличествоПопытокПриАктуализацииСтруктурыЗаказов.Значение) = Тип("Число") Тогда
		
		Результат = Справочники.Настройки.МаксимальноеКоличествоПопытокПриАктуализацииСтруктурыЗаказов.Значение;
		
	КонецЕсли; 	
	
	Возврат Результат;
	
КонецФункции //ПолучитьМаксимальноеКоличесствоПопытокПриАктиализацииСтруктурыЗаказов

Функция ПолучитьМаксимальноеКоличествоПредметовСнабженияДляПоискаИЗаменыСимволов() Экспорт
	
	Результат = 50;
	
	Если ЗначениеЗаполнено(Справочники.Настройки.МаксимальноеКоличествоПредметовСнабженияДляПоискаИЗаменыСимволов.Значение) И
		ТипЗнч(Справочники.Настройки.МаксимальноеКоличествоПредметовСнабженияДляПоискаИЗаменыСимволов.Значение) = Тип("Число") Тогда
		
		Результат = Справочники.Настройки.МаксимальноеКоличествоПредметовСнабженияДляПоискаИЗаменыСимволов.Значение;
		
	КонецЕсли; 	
	
	Возврат Результат;
	
КонецФункции //ПолучитьМаксимальноеКоличествоПредметовСнабженияДляПоискаИЗаменыСимволов

#Область Обмен_С_НСИ

Функция ОбменНСИ_ПолучитьИдентификаторАбонента() Экспорт
	Результат = "0122";
	
	Значение = Справочники.Настройки.ОбменНСИ_ИдентификаторАбонента.Значение;
	Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("Строка") Тогда		
		Результат = Значение;		
	КонецЕсли; 	 // Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("Строка") Тогда		
	
	Возврат Результат;
КонецФункции // ОбменНСИ_ПолучитьИдентификаторАбонента

Функция ОбменНСИ_ПолучательПочтовыхСообщений() Экспорт
	Результат = "nsiexchange@yandex.ru";
	
	Значение = Справочники.Настройки.ОбменНСИ_ПолучательПочтовыхСообщений.Значение;
	Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("Строка") Тогда		
		Результат = Значение;		
	КонецЕсли; 	 // Если ЗначениеЗаполнено(Значение) И ТипЗнч(Значение) = Тип("Строка") Тогда		
	
	Возврат Результат;
КонецФункции // ОбменНСИ_ПолучитьИдентификаторАбонента

#КонецОбласти