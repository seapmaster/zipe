
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ПредметСнабжения = Параметры.ПредметСнабжения;
	ЕдиницаИзмерения = Параметры.ЕдиницаИзмерения;
	Количество = 1;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	Закрыть(Количество);	
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры
