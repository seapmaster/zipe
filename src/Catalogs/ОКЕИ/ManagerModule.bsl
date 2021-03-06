// Функция возвращает дерево значений с данными ОКЕИ.
//

#Если Сервер Или ВнешнееСоединение Тогда
Функция ПолучитьДанныеКлассификатора() Экспорт

	Текст = Новый ТекстовыйДокумент;
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла();
	Макет = Справочники.ОКЕИ.ПолучитьМакет("КлассификаторЕдиницИзмерения");
	Макет.Записать(ИмяВременногоФайла);	
	Текст.Прочитать(ИмяВременногоФайла);
	ТекстМакета = Текст.ПолучитьТекст();
	
	Возврат ОбщегоНазначения.ЗначениеИзСтрокиXML(ТекстМакета);

КонецФункции
#КонецЕсли

Процедура ЗаполнитьКодыILMS() Экспорт
	
	ТаблДок = Справочники.ОКЕИ.ПолучитьМакет("КодыIMLS");
	Всего = ТаблДок.ВысотаТаблицы;
	
	СпрОКЕИ = Справочники.ОКЕИ;
	
	Для сч = 2 По Всего Цикл
		
		КодОбъекта  = СокрЛП(ТаблДок.Область(сч, 4, сч, 4).Текст);
		Обозначение = СокрЛП(ТаблДок.Область(сч, 1, сч, 1).Текст);
		Описание    = СокрЛП(ТаблДок.Область(сч, 2, сч, 2).Текст);
		
		НайдЭл = СпрОКЕИ.НайтиПоКоду(КодОбъекта);
		
		Если НЕ НайдЭл.Пустая() Тогда
			
			СпрОб = НайдЭл.ПолучитьОбъект();
			СпрОб.КодовоеОбозначениеILMS = Обозначение;
			СпрОб.ОписаниеILMS = Описание;
			
			Попытка
				СпрОб.Записать();
			Исключение
			    Ошибка = ОписаниеОшибки();
				Сообщить(Ошибка);
			КонецПопытки;
			
		КонецЕсли; 
		
	КонецЦикла;
	
КонецПроцедуры
 

#Область Прочее

&НаСервере
Процедура ОбработатьРезультатыПодбораНаСервере(Дерево, СоответствиеЕдиниц, Обновить = Ложь) Экспорт
	
	МассивВыбранныхСтрок = Новый Массив;
	МассивКодов = Новый Массив;
	
	НачатьТранзакцию();
	
	Попытка
		
		Для каждого СтрокаУровень1 Из Дерево.Строки Цикл
			Если СтрокаУровень1.Выбран Тогда
				Для каждого СтрокаУровень2 Из СтрокаУровень1.Строки Цикл
					Если СтрокаУровень2.Выбран Тогда
						Для каждого СтрокаУровень3 Из СтрокаУровень2.Строки Цикл
							Если СтрокаУровень3.Выбран Тогда
							
								ЕдиницаСсылка = СоответствиеЕдиниц.Получить(СокрЛП(СтрокаУровень3.КодЧисловой));
								Если ЕдиницаСсылка <> Неопределено Тогда
									Если Обновить Тогда
										СправочникОбъект = ЕдиницаСсылка.ПолучитьОбъект();
									Иначе
										Продолжить;
									КонецЕсли; 
								Иначе
									СправочникОбъект = Справочники.ОКЕИ.СоздатьЭлемент();
								КонецЕсли;
								
								//+ Савинов
								//Если ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеНациональное) Тогда
								//	Наименование = СтрокаУровень3.УсловноеОбозначениеНациональное;
								Если ЗначениеЗаполнено(СтрокаУровень3.Наименование) Тогда
									Наименование = СтрокаУровень3.Наименование;
								//- Савинов
								ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.УсловноеОбозначениеМеждународное) Тогда
									Наименование = СтрокаУровень3.УсловноеОбозначениеМеждународное;
								ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.КодовоеБуквенноеОбозначениеНациональное) Тогда
									Наименование = СтрокаУровень3.КодовоеБуквенноеОбозначениеНациональное;
								ИначеЕсли ЗначениеЗаполнено(СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное) Тогда
									Наименование = СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное;
								//+ Савинов
								//Иначе
								//	Наименование = СтрокаУровень3.Наименование;
								//- Савинов
								КонецЕсли;
								
								СправочникОбъект.Наименование            = СтрЗаменить(Наименование,Символы.ПС,"/");
								СправочникОбъект.МеждународноеСокращение = СтрЗаменить(СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное,Символы.ПС,"/");
								СправочникОбъект.НаименованиеПолное      = СтрЗаменить(СтрокаУровень3.Наименование,Символы.ПС,"/");
								СправочникОбъект.Код                     = СокрЛП(СтрокаУровень3.КодЧисловой);
								// +++
								
								//+ Савинов
								//СправочникОбъект.УсловноеОбозначениеНациональное  = СтрЗаменить(СтрокаУровень3.УсловноеОбозначениеНациональное, Символы.ПС,"/");
								//- Савинов
								
								СправочникОбъект.УсловноеОбозначениеМеждународное = СтрЗаменить(СтрокаУровень3.УсловноеОбозначениеМеждународное, Символы.ПС,"/");
								СправочникОбъект.КодовоеОбозначениеНациональное   = СтрЗаменить(СтрокаУровень3.КодовоеБуквенноеОбозначениеНациональное, Символы.ПС,"/");
								СправочникОбъект.КодовоеОбозначениеМеждународное  = СтрЗаменить(СтрокаУровень3.КодовоеБуквенноеОбозначениеМеждународное, Символы.ПС,"/");
								// ---
								
								
								Если ЗначениеЗаполнено(СтрокаУровень3.ТипИзмеряемойВеличины) Тогда
									СправочникОбъект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин[СтрокаУровень3.ТипИзмеряемойВеличины];
								Иначе 
									Попытка 
										// Там где не заполнено, берем наименование группы
										ТекстСтрока = СтрокаУровень2.Наименование;
										Если найти(СтрокаУровень2.Наименование, "Экноми") > 0 Тогда
											ТекстСтрока = СтрЗаменить(СтрокаУровень2.Наименование, "Экноми", "Экономи");
										КонецЕсли; 
										СправочникОбъект.ТипИзмеряемойВеличины = Перечисления.ТипыИзмеряемыхВеличин[СтрЗаменить(ТекстСтрока, " ", "")];
									Исключение
									    //ОписаниеОшибки()
									КонецПопытки;
								КонецЕсли;
								
								СправочникОбъект.Записать();
								
							КонецЕсли;
						КонецЦикла;
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
		КонецЦикла;
		
		ЗафиксироватьТранзакцию();
		
	Исключение
		
		ОтменитьТранзакцию();
		
		ТекстСообщения = НСтр("ru = 'Не удалось подобрать единицу измерения из классификатора.'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
		
		КодОсновногоЯзыка = ОбщегоНазначенияКлиентСервер.КодОсновногоЯзыка(); // Для записи события в журнал регистрации.
		ЗаписьЖурналаРегистрации(НСтр("ru = 'Подбор единиц измерения из классификатора.'", КодОсновногоЯзыка),
			УровеньЖурналаРегистрации.Ошибка, , ,
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
		
	КонецПопытки
	
КонецПроцедуры

&НаСервере
Процедура ОбработатьДерево(Дерево, Отбор, Соответствие) Экспорт
	
	МассивКУдалению = Новый Массив;
	ОбработатьУровень(Дерево.Строки, Отбор, МассивКУдалению, Соответствие, 1);
	УдалитьСтрокиИзКоллекцииСтрок(Дерево.Строки, МассивКУдалению);
		
КонецПроцедуры

&НаСервере
Процедура ОбработатьУровень(Строки, Отбор, МассивКУдалению, Соответствие, Уровень)
	
	Для каждого Строка Из Строки Цикл
		Если Уровень = 3 Тогда
			
			ТипТекущейСтроки = Перечисления.ТипыИзмеряемыхВеличин.ПустаяСсылка();
			Если ЗначениеЗаполнено(Строка.ТипИзмеряемойВеличины) Тогда 
				ТипТекущейСтроки = Перечисления.ТипыИзмеряемыхВеличин[Строка.ТипИзмеряемойВеличины];
			КонецЕсли;

			Если ТипЗнч(Отбор) = Тип("Массив") И ЗначениеЗаполнено(Отбор) И Отбор.Найти(ТипТекущейСтроки) = Неопределено Тогда
				МассивКУдалению.Добавить(Строка);
			Иначе
				Если Соответствие.Получить(Строка.КодЧисловой) <> Неопределено Тогда
					Строка.Существует = Истина;
				КонецЕсли;
			КонецЕсли;
			
		Иначе
			МассивКУдалениюСледующегоУровня = Новый Массив;
			ОбработатьУровень(Строка.Строки, Отбор, МассивКУдалениюСледующегоУровня, Соответствие, Уровень + 1);
			УдалитьСтрокиИзКоллекцииСтрок(Строка.Строки, МассивКУдалениюСледующегоУровня);
			Если Строка.Строки.Количество() = 0 Тогда
				МассивКУдалению.Добавить(Строка);	
			КонецЕсли;                
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура УдалитьСтрокиИзКоллекцииСтрок(Строки, МассивКУдалению)
	Для Каждого СтрокаКУдалению Из МассивКУдалению Цикл
		Строки.Удалить(СтрокаКУдалению);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти
