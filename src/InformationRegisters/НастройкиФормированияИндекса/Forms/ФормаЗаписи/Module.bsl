////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьСписокТабличныхЧастей(ИмяОбъекта, СписокТЧ)	
	СписокТЧ.Очистить();	
	Если ЗначениеЗаполнено(ИмяОбъекта) Тогда
		СписокТЧ.Добавить("Справочник." + ИмяОбъекта, "Справочник." + ИмяОбъекта);		 
		Для Каждого Реквизит Из Метаданные.Справочники[ИмяОбъекта].ТабличныеЧасти Цикл			
			СписокТЧ.Добавить("Справочник." + ИмяОбъекта + "." + Реквизит.Имя, "Справочник." + ИмяОбъекта + "." + Реквизит.Имя);			
		КонецЦикла;	
		СписокТЧ.Добавить("РегистрСведений.ДополнительныеНаименования", "РегистрСведений.ДополнительныеНаименования");
		СписокТЧ.Добавить("РегистрСведений.КодыINCATПредставление", 	"РегистрСведений.КодыINCATПредставление");
	КонецЕсли;  
КонецПроцедуры //ЗаполнитьСписокТабличныхЧастей

&НаСервере
Процедура ЗаполнитьСписокРеквизитов(ИмяОбъекта, ИмяТабличнойЧасти, СписокРеквизитов)  	
	СписокРеквизитов.Очистить();
	
	Если ЗначениеЗаполнено(ИмяОбъекта) И ЗначениеЗаполнено(ИмяТабличнойЧасти) Тогда 		
		Если ИмяТабличнойЧасти = "Справочник." + ИмяОбъекта Тогда 			
			Для Каждого Реквизит Из Метаданные.Справочники[ИмяОбъекта].СтандартныеРеквизиты Цикл 				
				СписокРеквизитов.Добавить(Реквизит.Имя, Реквизит.Синоним); 				
			КонецЦикла; 	
			
			Для Каждого Реквизит Из Метаданные.Справочники[ИмяОбъекта].Реквизиты Цикл				
				СписокРеквизитов.Добавить(Реквизит.Имя, Реквизит.Синоним); 				
			КонецЦикла; 			
		ИначеЕсли Лев(ИмяТабличнойЧасти, 11) = "Справочник." Тогда
			Для Каждого Реквизит Из Метаданные.Справочники[ИмяОбъекта].ТабличныеЧасти[Сред(ИмяТабличнойЧасти, 13 + СтрДлина(ИмяОбъекта))].Реквизиты Цикл				
				СписокРеквизитов.Добавить(Реквизит.Имя, Реквизит.Синоним);				
			КонецЦикла;
		ИначеЕсли Лев(ИмяТабличнойЧасти, 16) = "РегистрСведений." Тогда
			Для Каждого Реквизит Из Метаданные.РегистрыСведений[Сред(ИмяТабличнойЧасти, 17)].Ресурсы Цикл				
				СписокРеквизитов.Добавить(Реквизит.Имя, Реквизит.Синоним);				
			КонецЦикла;
		КонеЦЕсли;
	КонецЕсли;  	
КонецПроцедуры //ЗаполнитьСписокРеквизитов

&НаСервере
Процедура ИмяОбъектаПриИзмененииНаСервере() 	
	Запись.ИмяТабличнойЧасти = "";
	Запись.ИмяРеквизита = ""; 	
	ЗаполнитьСписокТабличныхЧастей(Запись.ИмяОбъекта, Элементы.ИмяТабличнойЧасти.СписокВыбора); 
	ЗаполнитьСписокРеквизитов(Запись.ИмяОбъекта, Запись.ИмяТабличнойЧасти, Элементы.ИмяРеквизита.СписокВыбора);
КонецПроцедуры //ИмяОбъектаПриИзмененииНаСервере

&НаСервере
Процедура ИмяТабличнойЧастиПриИзмененииНаСервере() 	
	Запись.ИмяРеквизита = ""; 	
	ЗаполнитьСписокРеквизитов(Запись.ИмяОбъекта, Запись.ИмяТабличнойЧасти, Элементы.ИмяРеквизита.СписокВыбора);		
КонецПроцедуры //ИмяТабличнойЧастиПриИзмененииНаСервере


////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ИмяОбъекта.СписокВыбора.Добавить("КаталогПредметовСнабжения", "Каталог предметов снабжения");
	Элементы.ИмяОбъекта.СписокВыбора.Добавить("СтруктураЗаказаПоКомплектующимИзделиямИЗИП", "Комплектующие изделия и ЗИП");
	ЗаполнитьСписокТабличныхЧастей(Запись.ИмяОбъекта, Элементы.ИмяТабличнойЧасти.СписокВыбора); 
	ЗаполнитьСписокРеквизитов(Запись.ИмяОбъекта, Запись.ИмяТабличнойЧасти, Элементы.ИмяРеквизита.СписокВыбора); 
КонецПроцедуры //ПриСозданииНаСервере

&НаКлиенте
Процедура ИмяОбъектаПриИзменении(Элемент)
	ИмяОбъектаПриИзмененииНаСервере();
КонецПроцедуры //ИмяОбъектаПриИзменении

&НаКлиенте
Процедура ИмяТабличнойЧастиПриИзменении(Элемент)
	ИмяТабличнойЧастиПриИзмененииНаСервере();
КонецПроцедуры //ИмяТабличнойЧастиПриИзменении

