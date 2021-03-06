////////////////////////////////////////////////////////////////////////////////
// Модуль предназначен для общих процедур и функций, 
// выполняемых как на клиенте, так и на сервере
// Создан по аналогии с модулями ОбщиеФункцииКлиент и ОбщиеФункцииСервер
// Веденеев П.А. 08.09.2017
////////////////////////////////////////////////////////////////////////////////

#Область СтроковыеФункции

//функция удаляет множественные символы из середины строки (пример - лишние пробелы),
//преобразуя любое количество последовательных вхождений символа в единичное вхождение,
//возвращает обработанное значение
Функция УдалитьПовторяющиесяСимволыИзСерединыСтроки(ОбрабатываемаяСтрока, ПроверяемыйСимвол) Экспорт
	
	 ПодстрокаПоиска = ПроверяемыйСимвол + ПроверяемыйСимвол;
	 
	 Пока Найти(ОбрабатываемаяСтрока, ПодстрокаПоиска) > 0 Цикл
		 
		  ОбрабатываемаяСтрока = СтрЗаменить(ОбрабатываемаяСтрока, ПодстрокаПоиска, ПроверяемыйСимвол);
	 	
	  КонецЦикла;
	  
	  Возврат ОбрабатываемаяСтрока;
	
КонецФункции

#КонецОбласти 

// Возвращает истина, т.к. подсистема БП перенесена в подсистему обмен данными, 
// а стандартный механизм поиска подсистем ищет только в стандартных подсистемах,
// нужно для отображения настроек.
Функция ЕстьПодсистемаБизнесПроцессы() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Функция предназначена для получения строки обозначения с заменой символов русского языка символами/сочетаниями символов английского
// Параметры:
// ТекущаяСтрока - Строка
//
Функция ТранслитироватьОбозначениеРусВАнг(Знач ТекущаяСтрока) Экспорт
	
	ТекущаяСтрока = ВРег(ТекущаяСтрока);
	
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"А","A");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Б","(B)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"В","B");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Г","(G)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Д","(D)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Е","E");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ё","(YO)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ж","(ZH)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"З","(Z)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"И","(I)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Й","(YE)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"К","K");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Л","(L)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"М","M");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Н","H");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"О","O");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"П","(P)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Р","P");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"С","C");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Т","T");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"У","Y");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ф","(F)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Х","X");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ц","(TS)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ч","(CH)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ш","(SH)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Щ","(SHCH)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ъ","(HB)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ы","(Y)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ь","(HC)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Э","(E)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Ю","(YU)");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,"Я","(YA)");

	Возврат ТекущаяСтрока;
	
КонецФункции

// Функция предназначена для получения строки обозначения с заменой символов английского языка символами/сочетаниями символов русского
// Параметры:
// ТекущаяСтрока - Строка
//
Функция ТранслитироватьОбозначениеАнгВРус(Знач ТекущаяСтрока) Экспорт
	
	ТекущаяСтрока = ВРег(ТекущаяСтрока);
	
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(SHCH)", "Щ");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(YO)", "Ё");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(ZH)", "Ж");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(YE)", "Й");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(TS)", "Ц");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(CH)", "Ч");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(SH)", "Ш");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(HB)", "Ъ");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(HC)", "Ь");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(YU)", "Ю");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(YA)", "Я");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(B)",  "Б");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(G)",  "Г");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(D)",  "Д");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(Z)",  "З");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(I)",  "И");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(L)",  "Л");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(P)",  "П");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(F)",  "Ф");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(Y)",  "Ы");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока, "(E)",  "Э");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "A",   "А");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "B",   "В");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "E",   "Е");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "K",   "К");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "M",   "М");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "H",   "Н");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "O",   "О");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "P",   "Р");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "C",   "С");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "T",   "Т");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "Y",   "У");
	ТекущаяСтрока = СтрЗаменить(ТекущаяСтрока,  "X",   "Х");
	
	Возврат ТекущаяСтрока;
	
КонецФункции
