
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЭтаФорма.Параметры.Свойство("ОбъектИзменений") Тогда
		Отчет.ОбъектИзменений = ЭтаФорма.Параметры.ОбъектИзменений;
	КонецЕсли; 
	
	Параметры.СформироватьПриОткрытии = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗагрузкойВариантаНаСервере(Настройки)
	
	Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОбъектИзменений",Отчет.ОбъектИзменений);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОбъектИзмененийПриИзменении(Элемент)
	
	УстановитьПараметрыНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьПараметрыНаСервере()
	
	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.УстановитьЗначениеПараметра("ОбъектИзменений",Отчет.ОбъектИзменений);
	
КонецПроцедуры

#КонецОбласти