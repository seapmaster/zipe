
Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Представление = "Запрос ТКП-RFP № " + Данные.НомерЗаказчика + " от " + Формат(Данные.Дата, "ДФ=dd.MM.yyyy");
	
КонецПроцедуры

Процедура ОбработкаПолученияПолейПредставления(Поля, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Поля.Добавить("НомерЗаказчика");
	Поля.Добавить("Дата");
	
КонецПроцедуры
