
////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

Процедура УстановитьПредставление(Объект, Представление) Экспорт
	
	Запись 							 = РегистрыСведений.ПоисковыйИндекс.СоздатьМенеджерЗаписи();
	
	Запись.Объект 					 = Объект;
	Запись.Представление 			 = Представление;
	
	Запись.Записать();
	
КонецПроцедуры //УстановитьПредставление

#КонецОбласти