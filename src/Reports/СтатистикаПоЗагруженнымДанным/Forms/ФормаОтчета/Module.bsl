

&НаСервере
Процедура СохранитьСтатистикуНаСервере()
	
   ОтчетОбъект = РеквизитФормыВЗначение("Отчет"); 
   ОтчетОбъект.СохранитьСтатистикуНаполненияБД();
	
КонецПроцедуры


&НаКлиенте
Процедура СохранитьСтатистику(Команда)
	СохранитьСтатистикуНаСервере();
КонецПроцедуры

