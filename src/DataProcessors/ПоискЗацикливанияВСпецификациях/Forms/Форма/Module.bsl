
//////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

&НаКлиенте
Процедура Поиск(Команда)
	
	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();

	ПоискНаСервере();
	
	ВремяКонца = ТекущаяУниверсальнаяДатаВМиллисекундах();

	Информация = СтрШаблон(НСтр("ru = 'Время поиска(мсек) %1.'"), (ВремяКонца - ВремяНачала));

КонецПроцедуры //Поиск

&НаКлиенте
Процедура ПоискЗапросом(Команда)
	
	ВремяНачала = ТекущаяУниверсальнаяДатаВМиллисекундах();

	ПоискЗапросомНаСервере();
	
	ВремяКонца = ТекущаяУниверсальнаяДатаВМиллисекундах();

	Информация = СтрШаблон(НСтр("ru = 'Время поиска(мсек) %1. Максимальный уровень вложенности = %2'"), (ВремяКонца - ВремяНачала), МаксимальныйУровень);

КонецПроцедуры //ПоискЗапросом

//////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

#Область СлужебныеПроцедурыИФункции

Функция ИнициализироватьДеревоРезультат()
	
	ДеревоРезультат = Новый ДеревоЗначений;
	ДеревоРезультат.Колонки.Добавить("ПредметСнабжения", Новый ОписаниеТипов("СправочникСсылка.КаталогПредметовСнабжения"));
	ДеревоРезультат.Колонки.Добавить("Ошибка", Новый ОписаниеТипов("Булево"));

	Возврат ДеревоРезультат;
	
КонецФункции // ИнициализироватьДеревоРезультат() 
	
#КонецОбласти 

#Область ПоискРекурсией

&НаСервере
Процедура ПоискНаСервере()
	
	МассивПредметовСнабжения = ПолучитьМассивПредметовСнабжения();
	
	ДеревоСпецификацииСервер = ИнициализироватьДеревоРезультат();
	
	Для каждого ПредметСнабжения Из МассивПредметовСнабжения Цикл
		
		СтрокаДерева = ДеревоСпецификацииСервер.Строки.Добавить();
		СтрокаДерева.ПредметСнабжения = ПредметСнабжения;
		
		Спецификации = Новый Массив();
		Спецификации.Добавить(ПредметСнабжения);
		
		Ошибка = Ложь;
		
		ЗаполнитьДеревоСпецификации(СтрокаДерева.Строки, ПредметСнабжения, Спецификации, Ошибка);
		
		СтрокаДерева.Ошибка = Ошибка;

	КонецЦикла;	
	
	ОбработатьДеревоОшибок(ДеревоСпецификацииСервер);
	
	ЗначениеВДанныеФормы(ДеревоСпецификацииСервер, ДеревоСпецификации);

КонецПроцедуры //ПоискНаСервере

&НаСервере
Функция ПолучитьМассивПредметовСнабжения()

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СпецификацииПС.ПредметСнабжения КАК ПредметСнабжения
	|ИЗ
	|	РегистрСведений.СпецификацииПС КАК СпецификацииПС
	|
	|УПОРЯДОЧИТЬ ПО
	|	СпецификацииПС.ПредметСнабжения";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("ПредметСнабжения");
		
КонецФункции // ПолучитьМассивПредметовСнабжения()

&НаСервере
Процедура ЗаполнитьДеревоСпецификации(СтрокиДерева, ПредметСнабжения, Спецификации = Неопределено, Ошибка = Ложь) Экспорт
	
	Если Спецификации = Неопределено Тогда
		Спецификации = Новый Массив();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	СпецификацииПС.СоставляющаяЧасть КАК ПредметСнабжения
	|ИЗ
	|	РегистрСведений.СпецификацииПС КАК СпецификацииПС
	|ГДЕ
	|	СпецификацииПС.ПредметСнабжения = &ПредметСнабжения";
	
	Запрос.УстановитьПараметр("ПредметСнабжения", ПредметСнабжения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		
		НоваяСтрока = СтрокиДерева.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, Выборка);
		
		Если Спецификации.Найти(НоваяСтрока.ПредметСнабжения) = Неопределено Тогда
			
			Спецификации.Вставить(0, НоваяСтрока.ПредметСнабжения);
			
			ЗаполнитьДеревоСпецификации(НоваяСтрока.Строки, НоваяСтрока.ПредметСнабжения, Спецификации, НоваяСтрока.Ошибка);
			Если НЕ Ошибка И НоваяСтрока.Ошибка Тогда
			
				 Ошибка = Истина;
			
			КонецЕсли; 
						
			Спецификации.Удалить(0);
			
		Иначе
			
			НоваяСтрока.Ошибка = Истина;
			Ошибка = Истина;

			Прервать;
			
		КонецЕсли; 	
					
	КонецЦикла;
	
КонецПроцедуры  //ЗаполнитьДеревоСпецификации

&НаСервере
Процедура ОбработатьДеревоОшибок(ДеревоОшибок) 
	
	МассивУдаляемыхСтрок = Новый Массив;
	
	Для Каждого Строка Из ДеревоОшибок.Строки Цикл
		Если НЕ Строка.Ошибка Тогда
			МассивУдаляемыхСтрок.Добавить(Строка);
		Иначе
			ОбработатьДеревоОшибок(Строка);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого УдаляемаяСтрока Из МассивУдаляемыхСтрок Цикл
		ДеревоОшибок.Строки.Удалить(УдаляемаяСтрока);
	КонецЦикла;
			
КонецПроцедуры //ОбработатьДеревоОшибок

#КонецОбласти 

#Область ПоискЗапросом

&НаСервере
Процедура ПоискЗапросомНаСервере()
	
	ДеревоСпецификацииСервер = ИнициализироватьДеревоРезультат();
	
	ПоискЗапросомПоПредметамСнабжения(ДеревоСпецификацииСервер);
	
	ЗначениеВДанныеФормы(ДеревоСпецификацииСервер, ДеревоСпецификации);

КонецПроцедуры //ПоискЗапросомНаСервере

&НаСервере
Процедура ПоискЗапросомПоПредметамСнабжения(ДеревоОшибок)
	
	КоличествоЦиклов = 50;
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	
	Запрос.Текст = ПолучитьТекстЗапросаПредметыСнабжения();
	Запрос.Выполнить();

	Запрос.Текст = ПолучитьТекстЗапросаСпецификации();
	Запрос.Выполнить();		
	
	ТекстЗапроса = ПолучитьТекстЗапросаСлужебныеТаблицы();
	
	Для Счетчик = 0 по КоличествоЦиклов  Цикл
		
		Запрос.Текст = СтрЗаменить(ТекстЗапроса, "Исходная",    "ВремТаблица" + Счетчик);
		Запрос.Текст = СтрЗаменить(Запрос.Текст, "Последующая", "ВремТаблица" + (Счетчик + 1));
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Если РезультатЗапроса.Пустой() Тогда 
			Счетчик = Счетчик + 1 ;
			Прервать;
		КонецЕсли;
		
	КонецЦикла;
	
	Если Не РезультатЗапроса.Пустой() Тогда
		 Сообщить("Обнаружено превышение максимального уровня вложенности " + Строка(КоличествоЦиклов)+" !");
	КонецЕсли;
	
	Запрос.Текст = ПолучитьТекстЗапросаОшибок(Счетчик); 
	РезультатОшибок = Запрос.Выполнить();
	Запрос.МенеджерВременныхТаблиц.Закрыть();
	
	ПоместитьРезультатВДеревоОшибок(РезультатОшибок, ДеревоОшибок, 0);
				
КонецПроцедуры //ПоискЗапросомПоПредметамСнабжения  

&НаСервере
Функция ПолучитьТекстЗапросаПредметыСнабжения()	
	
	Возврат
	"ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СпецификацииПС.ПредметСнабжения КАК ПредметСнабжения,
	|	""%%"" + ВЫРАЗИТЬ(СпецификацииПС.ПредметСнабжения.Код КАК СТРОКА(9)) + ""%""  КАК СтрокаКодов,
	|   0 КАК ПризнакКонцаВетки
	|ПОМЕСТИТЬ ВремТаблица0
	|ИЗ
	|	РегистрСведений.СпецификацииПС КАК СпецификацииПС
	|
	|";

КонецФункции //ПолучитьТекстЗапросаПредметыСнабжения

&НаСервере
Функция ПолучитьТекстЗапросаСпецификации()	
	
	Возврат
	"ВЫБРАТЬ
	|	Спец.ПредметСнабжения КАК ПредметСнабжения,
	|	Спец.СоставляющаяЧасть КАК СоставляющаяЧасть,
	|	""%"" + ВЫРАЗИТЬ(Спец.СоставляющаяЧасть.Код КАК СТРОКА(9)) + ""%""  КАК КодПредметаСнабжения
	|ПОМЕСТИТЬ Спецификация
	|ИЗ  РегистрСведений.СпецификацииПС КАК Спец
	|	ГДЕ (НЕ Спец.ПредметСнабжения.ПометкаУдаления)
	|ИНДЕКСИРОВАТЬ ПО
	|	ПредметСнабжения";

КонецФункции //ПолучитьТекстЗапросаСпецификации	

&НаСервере
Функция ПолучитьТекстЗапросаСлужебныеТаблицы()

	Возврат
	"ВЫБРАТЬ
	|    ЕСТЬNULL(Спец.СоставляющаяЧасть, Исх.ПредметСнабжения)        КАК ПредметСнабжения,
	|    Исх.СтрокаКодов + ЕСТЬNULL(Спец.КодПредметаСнабжения, """")   КАК СтрокаКодов,
	|    ВЫБОР
	|        КОГДА Исх.ПризнакКонцаВетки > 0 			      			    ТОГДА Исх.ПризнакКонцаВетки
	|        КОГДА Спец.КодПредметаСнабжения ЕСТЬ NULL        			    ТОГДА 1 // нормальное завершение ветки
	|        КОГДА Исх.СтрокаКодов ПОДОБНО Спец.КодПредметаСнабжения        ТОГДА 2 // зацикливание
	|        ИНАЧЕ      												    0		// ветка продолжается
	|    КОНЕЦ                                                         КАК ПризнакКонцаВетки
	|ПОМЕСТИТЬ Последующая
	|ИЗ
	|    Исходная КАК Исх
	|     ЛЕВОЕ СОЕДИНЕНИЕ Спецификация КАК Спец
	|     ПО (Исх.ПризнакКонцаВетки = 0) // соединяемся только тогда, когда ветка продолжается
	|            И Исх.ПредметСнабжения = Спец.ПредметСнабжения
	|;
	|УНИЧТОЖИТЬ Исходная
	|;
	|ВЫБРАТЬ ПЕРВЫЕ 1 Посл.ПредметСнабжения
	|ИЗ  Последующая КАК Посл
	|ГДЕ Посл.ПризнакКонцаВетки = 0";


КонецФункции // ПолучитьТекстЗапросаСлужебныеТаблицы()
 
&НаСервере
Функция ПолучитьТекстЗапросаОшибок(Счетчик)	
	
	ПоляВыборки = "";
	ПоляИтогов = "";
	
	Для н = 0 По Счетчик - 1 Цикл
		
		ПоляВыборки = ПоляВыборки + ",ПОДСТРОКА(Исх.СтрокаКодов ," + (11*н+3) + ",9) КАК Уровень"+н;
		ПоляИтогов  = ПоляИтогов + ", Уровень" + н; 
		
	КонецЦикла;
	
	ПоляВыборки = ПоляВыборки + ",
	|ПОДСТРОКА(Исх.СтрокаКодов ," +(11*н+3)+ ",0) КАК Уровень"+н+", 
	|Исх.ПредметСнабжения КАК ПредметСнабжения";
	
	ТекстЗапроса = 
	"ВЫБРАТЬ "+
	Сред(ПоляВыборки,2)+
	" 
	|ИЗ ВремТаблица" + Счетчик + " Как Исх 
	|ГДЕ Исх.ПризнакКонцаВетки = 2
	|ИТОГИ 
	|МАКСИМУМ(ПредметСнабжения) ПО " + Сред(ПоляИтогов,2) + " Автоупорядочивание";
	
	Возврат ТекстЗапроса;
	
КонецФункции //ПолучитьТекстЗапросаОшибок	

&НаСервере
Процедура ПоместитьРезультатВДеревоОшибок(Результат, Дерево, Уровень)

	Если Уровень > КоличествоЦиклов Тогда
	
		Возврат;	
	
	КонецЕсли; 
	
	Если Уровень > МаксимальныйУровень Тогда
	
		МаксимальныйУровень = Уровень;
	
	КонецЕсли; 
	
	Выборка = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	
	Пока Выборка.Следующий() Цикл
		
		Узел = Выборка["Уровень" + Уровень];
		
		Если ЗначениеЗаполнено(Узел) Тогда
			
			НоваяСтрока = Дерево.Строки.Добавить();
			НоваяСтрока.ПредметСнабжения = Справочники.КаталогПредметовСнабжения.НайтиПоКоду(Узел);
			
			ПоместитьРезультатВДеревоОшибок(Выборка, НоваяСтрока, Уровень + 1);		
			
		Иначе
			
			Прервать;
			
		КонецЕсли;
		
	КонецЦикла; 	

КонецПроцедуры //ПоместитьРезультатВДеревоОшибок  

&НаКлиенте
Процедура ДеревоСпецификацииВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	ТекущаяСтрока = Элементы.ДеревоСпецификации.ТекущиеДанные;
	
	ОткрытьФорму("Справочник.КаталогПредметовСнабжения.Форма.ФормаЭлементаНоваяРедакция", Новый Структура("Ключ", ТекущаяСтрока.ПредметСнабжения), ЭтаФорма);
	
КонецПроцедуры
	
#КонецОбласти
