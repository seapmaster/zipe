/////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

&НаСервере
Процедура ЗаполнитьICAT()
	INCAT = РегистрыСведений.КодыINCATПредставление.ПолучитьICAT(Объект.ПредметСнабжения);
КонецПроцедуры // ЗаполнитьICAT


&НаСервере
Процедура ЗаполнитьИзображения()
	
	Если НЕ ЗначениеЗаполнено(Объект.ПредметСнабжения) Тогда
		Возврат;
	КонецЕсли; 

	МассивРасширенийКартинок = Новый Массив;
	МассивРасширенийКартинок.Добавить("bmp");
	МассивРасширенийКартинок.Добавить("dib");
	МассивРасширенийКартинок.Добавить("rle");
	МассивРасширенийКартинок.Добавить("gif");
	МассивРасширенийКартинок.Добавить("jpg");
	МассивРасширенийКартинок.Добавить("jpeg");
	МассивРасширенийКартинок.Добавить("png");
	МассивРасширенийКартинок.Добавить("tif");
	МассивРасширенийКартинок.Добавить("ico");
	МассивРасширенийКартинок.Добавить("wmf");
	МассивРасширенийКартинок.Добавить("emf");
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ПрисоединенныеФайлы.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.КаталогПредметовСнабженияПрисоединенныеФайлы КАК ПрисоединенныеФайлы
	|ГДЕ
	|	ПрисоединенныеФайлы.ВладелецФайла = &ВладелецФайла
	|	И ПрисоединенныеФайлы.Расширение В(&МассивРасширенийКартинок)
	|	И НЕ ПрисоединенныеФайлы.Чертеж";
	
	Запрос.УстановитьПараметр("ВладелецФайла", Объект.ПредметСнабжения);
	Запрос.УстановитьПараметр("МассивРасширенийКартинок", МассивРасширенийКартинок);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		//++ 18.12.2017 Веденеев П. //отображение пустой картинки при отсутствии картинок
		АдресКартинки = ПоместитьВоВременноеХранилище(БиблиотекаКартинок.КартинкаПустая.ПолучитьДвоичныеДанные());
		//-- 18.12.2017 Веденеев П. //отображение пустой картинки при отсутствии картинок
		
		Возврат;	
	
	КонецЕсли;
	
	Выборка = РезультатЗапроса.Выбрать();
	
	КоличествоИзображений = Выборка.Количество();
	
	Пока Выборка.Следующий() Цикл
	
		Изображения.Добавить(ПрисоединенныеФайлы.ПолучитьДанныеФайла(Выборка.Ссылка, УникальныйИдентификатор).СсылкаНаДвоичныеДанныеФайла);
	
	КонецЦикла;
	
	АдресКартинки = Изображения.Получить(0).Значение;
	
	Элементы.СледующееИзображение.Доступность = КоличествоИзображений > 1;
	
	НомерТекущегоИзображения = 0;

КонецПроцедуры // ЗаполнитьИзображения()

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда //++ 27.02.2018 Веденеев П.
		
		НаименованиеДополнительное = СтруктураЗаказаСервер.ПолучитьДополнительноеНаименование(Объект.Ссылка);
	
	ИначеЕсли Параметры.Свойство("Ссылка") Тогда
		
		ЗначениеВРеквизитФормы(Параметры.Ссылка.ПолучитьОбъект(), "Объект");
		
	Иначе
		
		Если Не Параметры.Свойство("Владелец") Тогда
			
			Отказ = Истина;
			Сообщить("Запрещено создавать элемент без предварительного выбора его владельца.");
			Возврат;
			
		КонецЕсли;
		
		Объект.Владелец = Параметры.Владелец;
		
		Если Не Параметры.Свойство("ПредметСнабжения") Тогда
			
			Отказ = Истина;
			Сообщить("Запрещено создавать элемент с типом ""СЧ/ЗИП"" без предварительного выбора его предмета снабжения.");
			Возврат;
			
		КонецЕсли;
		
		Объект.ПредметСнабжения = Параметры.ПредметСнабжения;
		Объект.Наименование = Строка(Объект.ПредметСнабжения);
		
		Если Параметры.Свойство("ЗИП") Тогда
			
			Объект.ЗИП 	= Параметры.ЗИП;
			
			Если Параметры.Свойство("Заведование") Тогда
			
				Объект.Заведование 	= Параметры.Заведование;
				
			КонецЕсли;
			
		КонецЕсли;
		
		Если Параметры.Свойство("Родитель") Тогда
			
			Объект.Родитель 	= Параметры.Родитель;
			Объект.Заведование 	= Параметры.Заведование;	
			
		КонецЕсли;
		
		Объект.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Изделие;		
		
	КонецЕсли;
	
	ЗИПБыло = Объект.ЗИП;
	
	
	НаименованиеДополнительное = СтруктураЗаказаСервер.ПолучитьДополнительноеНаименование(Объект.ПредметСнабжения, ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(Объект.Владелец, "Заказчик"), "ЯзыкПредставленияДанных"));
	
	ЗаполнитьОписаниеИерархии();
	ЗаполнитьИзображения();
	
	//++ 12.04.2018 Веденеев П. //установка параметров динамических списков
	ПараметрПредметСнабжения = ?(ЗначениеЗаполнено(Объект.ПредметСнабжения), Объект.ПредметСнабжения, Неопределено);
	
	ВходитВСостав.Параметры.УстановитьЗначениеПараметра("СоставляющаяЧасть", ПараметрПредметСнабжения);
	ЦеныВнешние.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	ЦеныВнутренние.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	СпецификацияПредметаСнабжения.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	РесурсыИСрокиСлужбы.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	РегламентТОиР.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	СписокЗИПдляТОиР.Параметры.УстановитьЗначениеПараметра("ПредметСнабжения", ПараметрПредметСнабжения);
	//-- 12.04.2018 Веденеев П. //установка параметров динамических списков
	
	Элементы.ГруппаЗИП.ТолькоПросмотр = Объект.ДобавленИзСпецификации;
	Элементы.ГруппаХранение.Видимость = Объект.ЗИП;
	
	Элементы.НаименованиеДополнительное.ТолькоПросмотр 	= ТолькоПросмотр;
	Элементы.Количество.ТолькоПросмотр 			= ТолькоПросмотр;
	
	Если Не РольДоступна("ПолныеПрава") И РольДоступна("ИностранныйЗаказчик") Тогда
		
		Элементы.Заведование.Видимость = Ложь;
		
	КонецЕсли;
	
	//ДобавитьИЗаполнитьГородВПоставщиках();
	
	//++ 22.01.2018 Веденеев П. //заполнение данных об экземплярах элемента структуры
	
	ЭкземплярыВидимость = Не Объект.ЗИП И ЗначениеЗаполнено(Объект.Ссылка);//++ 19.01.18 Веденеев П. //закладка Экземпляры доступна только для комплектующих изделий
	Элементы.ГруппаЭкземпляры.Видимость = ЭкземплярыВидимость; 
	
	// ++ 09.07.2018 15:08:17 Базунов Д.А. Задача: 
	// Переопределим видимость по доступу
	Если ЭкземплярыВидимость Тогда
		Элементы.ГруппаЭкземпляры.Видимость = ПравоДоступа("Чтение", Метаданные.Справочники.ЭкземплярыКомплектующихИзделийКорабля);
	КонецЕсли; 
	// -- 09.07.2018 15:08:17 Базунов Д.А. Задача:
	
	УстановитьНастройкиЗакладкиЭкземпляры();
	
	//-- 22.01.2018 Веденеев П. //заполнение данных об экземплярах элемента структуры
	
	// Базунов 04.07.2018 На уровне прав на форме не удалось настроить видимость
	// Копия кода из спр. ПредметовСнабжения
	ВидимостьПоставщиков = РольДоступна("ПредставительКонтрагента");
	ВидимостьВнешнихЦен = РольДоступна("РуководительДепартаментаВТС") ИЛИ РольДоступна("РуководительПроектаДепартаментаВТС")
	ИЛИ РольДоступна("РуководительПроектаИССЗИПЭ") ИЛИ РольДоступна("СпециалистДепартаментаЭкономикиОСК") ИЛИ РольДоступна("ПолныеПрава");
	
	Элементы.ГруппаЦеныВнешние.Видимость = ВидимостьВнешнихЦен;
	Элементы.ГруппаПоставщики.Видимость  = НЕ ВидимостьПоставщиков;
	// Базунов 04.07.2018 

	
	//++ 06.03.2018 Веденеев П. //автозаполнение типа составляющей части для нового элемента
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		
		Объект.ТипСоставляющейЧасти = ?(Объект.ЗИП, Константы.РазделСпецификацииЗИП.Получить(), Константы.РазделСпецификацииИзделие.Получить());
		
	КонецЕсли;
	//-- 06.03.2018 Веденеев П. //автозаполнение типа составляющей части для нового элемента
	
	//++ 15.03.2018 Веденеев П. //доступность операций изменения данных зависит от наличия БП на их изменение
	Если ПолучитьФункциональнуюОпцию("ИспользоватьБизнесПроцессыДляРедактированияСтруктурыКорабля") 
		И Не КорректировкаДанныхСправочников.КорабльНаходитсяВПроцессеРедактирования(Объект.Владелец) Тогда
		
		КорректировкаДанныхСправочников.ОтключитьНепосредственноеИзменениеДанных(ЭтаФорма, Ложь);
		Элементы.Количество.ТолькоПросмотр = Истина;
		
	КонецЕсли;
	//-- 15.03.2018 Веденеев П. //доступность операций изменения данных зависит от наличия БП на их изменение
	
	ЗаполнитьICAT();
	
КонецПроцедуры

//+ 22.11.2017 16:14:31 Базунов Д.А. Задача: Пока не работает
&НаСервере
Процедура ДобавитьИЗаполнитьГородВПоставщиках()
	
	МассивРеквизитов = Новый Массив;
	МассивРеквизитов.Добавить(Новый РеквизитФормы("ПоставщикиГород", Новый ОписаниеТипов("Строка"), "Объект.ПредметСнабжения.ИзготовителиИПоставщики", "Город"));
	ИзменитьРеквизиты(МассивРеквизитов);
	
	КолонкаГород = Элементы.Вставить("ИзготовителиИПоставщикиГород", Тип("ПолеФормы"), Элементы.ПредметСнабженияИзготовителиИПоставщики, Элементы.ПредметСнабженияИзготовителиИПоставщикиПоставщик);
	КолонкаГород.Вид = ВидПоляФормы.ПолеВвода;
	КолонкаГород.ПутьКДанным = "Объект.ПредметСнабжения.ИзготовителиИПоставщики.ПоставщикиГород";
	
	ОбновитьГородВПоставщиках();
	
КонецПроцедуры

&НаСервере
Процедура ОбновитьГородВПоставщиках()
	
	Если Объект.ИзготовителиИПоставщики.Количество() > 0 Тогда
		Для Каждого ТекЭлемент Из Объект.ИзготовителиИПоставщики Цикл
			ПоискАдрес = ТекЭлемент.Контрагент.КонтактнаяИнформация.НайтиСтроки(Новый Структура("Тип", Перечисления.ТипыКонтактнойИнформации.Адрес));
			Если ПоискАдрес.Количество() > 0 Тогда
				ТекАдрес = ПоискАдрес[0];
				Если ТекАдрес.Город = "" Тогда
					ТекЭлемент.ПоставщикиГород = ТекАдрес.Регион;
				Иначе
					ТекЭлемент.ПоставщикиГород = ТекАдрес.Город;
				КонецЕсли; 
			КонецЕсли; 
		КонецЦикла; 
	КонецЕсли; 
	
КонецПроцедуры
//- 22.11.2017 16:14:31 Базунов Д.А. Задача: 

&НаСервере
Процедура ЗаполнитьОписаниеИерархии()

	ОписаниеИерархии = ?(ЗначениеЗаполнено(Объект.Ссылка), СтруктураЗаказаСервер.ПолучитьОписаниеИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП(Объект.Ссылка), СтруктураЗаказаСервер.СформироватьОписаниеИерархииЭлементовСтруктурыЗаказовПоКомплектующимИзделиямИЗИП(Объект.Родитель));	

КонецПроцедуры // ЗаполнитьОписаниеИерархии()

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	РезультатПроверкиЗаполненияРеквизитов = ПроверитьЗаполнениеРеквизитов();
	
	Если РезультатПроверкиЗаполненияРеквизитов.ЕстьЗамечания Тогда
	
		Отказ = Истина;
		Сообщить(РезультатПроверкиЗаполненияРеквизитов.Описание);
		Возврат;
	
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Функция ПроверитьЗаполнениеРеквизитов()
	
	Результат = Новый Структура("ЕстьЗамечания, Описание", Ложь, "");

	МассивЗамечаний = Новый Массив;
	
	//Если Не ЗначениеЗаполнено(НаименованиеДополнительное) Тогда
	//
	//	МассивЗамечаний.Добавить("Не заполнено наименование (доп.)");
	//	МассивЗамечаний.Добавить(Символы.ПС);		
	//
	//КонецЕсли;
	//
	//Если Не ЗначениеЗаполнено(Объект.Количество) Тогда
	//	
	//	МассивЗамечаний.Добавить("Не заполнено количество");
	//	МассивЗамечаний.Добавить(Символы.ПС);	
	//	
	//КонецЕсли;
	
	Если МассивЗамечаний.Количество() > 0 Тогда
		
		МассивЗамечаний.Удалить(МассивЗамечаний.Количество() - 1);
		Результат.Описание = СтрСоединить(МассивЗамечаний);
		Результат.ЕстьЗамечания = Истина;
		 
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // ПроверитьЗаполнениеРеквизитов()

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	ЗаписьБылаПроизведена = Истина;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Если Не ЗавершениеРаботы И Не ЗакрытиеОбработано Тогда
		
		Если Модифицированность Тогда
			
			Отказ = Истина;
			
			ОписаниеОповещения = Новый ОписаниеОповещения("ПередЗакрытиемПродолжение", ЭтотОбъект);
			
			ПоказатьВопрос(ОписаниеОповещения, "Данные были изменены. Сохранить изменения?", РежимДиалогаВопрос.ДаНетОтмена,,, "1С:Предприятие");
			
		Иначе
			
			ПередЗакрытиемПродолжение(КодВозвратаДиалога.Нет);		
			
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемПродолжение(Ответ, ДопПараметры = Неопределено) Экспорт

	Если Ответ = КодВозвратаДиалога.Отмена Тогда
	
		Возврат;	
	
	КонецЕсли;
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
	
		Записать();	
	
	КонецЕсли;	
	
	ЗакрытиеОбработано = Истина;
	
	Если ЗаписьБылаПроизведена Тогда
	
		СтруктураЗакрытия = Новый Структура;
		СтруктураЗакрытия.Вставить("ЗаписьБылаПроизведена", ЗаписьБылаПроизведена);	
		
		Если ПредметСнабженияИмеетСпецификацию Тогда
		
			СтруктураЗакрытия.Вставить("ПредметСнабженияИмеетСпецификацию", ПредметСнабженияИмеетСпецификацию);
			СтруктураЗакрытия.Вставить("ЭлементСтруктуры", Объект.Ссылка);
			СтруктураЗакрытия.Вставить("Заведование", Объект.Заведование);
			СтруктураЗакрытия.Вставить("ПредметСнабжения", Объект.ПредметСнабжения);
		
		КонецЕсли;
		
		Закрыть(СтруктураЗакрытия);
	
	Иначе
	
		Закрыть();	
	
	КонецЕсли;

КонецПроцедуры // ПередЗакрытиемПродолжение()

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	ПредметСнабженияИмеетСпецификацию = СпецификацииПредметовСнабжения.ПредметСнабженияИмеетСпецификацию(ТекущийОбъект.ПредметСнабжения);
	
	//++ 22.01.2018 Веденеев П. //включаем видимость закладки "Экземпляры", если это не ЗИП
	
	Элементы.ГруппаЭкземпляры.Видимость = Не Объект.ЗИП;
	
	УстановитьНастройкиЗакладкиЭкземпляры();
	
	//-- 22.01.2018 Веденеев П. //включаем видимость закладки "Экземпляры", если это не ЗИП
	
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеДополнительноеПриИзменении(Элемент)
	
	МодифицированностьДопНаименования = Истина;
	Модифицированность = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)	
	
	Если МодифицированностьДопНаименования Тогда
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить("Язык", ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(ОбщиеФункцииСервер.ПолучитьЗначениеРеквизита(ТекущийОбъект.Владелец, "Заказчик"), "ЯзыкПредставленияДанных"));
		ТекущийОбъект.ДополнительныеСвойства.Вставить("НаименованиеДополнительное", НаименованиеДополнительное);
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ПредметСнабжения", ТекущийОбъект.ПредметСнабжения);
		
	КонецЕсли; 
	
	Если Не ЗначениеЗаполнено(ТекущийОбъект.Ссылка) И ЗначениеЗаполнено(ОписаниеИерархии) Тогда
		
		ТекущийОбъект.ДополнительныеСвойства.Вставить("ОписаниеИерархии", ОписаниеИерархии);	
		
	КонецЕсли;
	
	//++ 05.03.2018 Веденеев П. //добавлено изменение типа составляющей части
	Если Не ЗИПБыло = Объект.ЗИП Или Не Объект.ТипСоставляющейЧасти = Объект.Ссылка.ТипСоставляющейЧасти Тогда
		
		//НаборЗаписи = РегистрыСведений.СпецификацииПредметовСнабжения.СоздатьНаборЗаписей();
		//НаборЗаписи.Отбор.ПредметСнабжения.Установить(Объект.Родитель.ПредметСнабжения);
		//НаборЗаписи.Отбор.СоставляющаяЧасть.Установить(Объект.ПредметСнабжения);
		//НаборЗаписи.Прочитать();
		//
		//Если НаборЗаписи.Количество() = 1 Тогда
		//	
		//	Если Не Объект.ЗИП = Объект.Ссылка.ЗИП Тогда
		//		
		//		НаборЗаписи[0].ЗИП = Объект.ЗИП;
		//		НаборЗаписи.Записать();
		//		
		//	КонецЕсли;
		//	
		//	Если Не Объект.ТипСоставляющейЧасти = Объект.Ссылка.ТипСоставляющейЧасти Тогда
		//		
		//		НаборЗаписи[0].Тип = Объект.ТипСоставляющейЧасти;
		//		НаборЗаписи.Записать();
		//		
		//	КонецЕсли;
		//	
		//КонецЕсли; 
		//
		//МенЗаписи = РегистрыСведений.СпецификацииПредметовСнабженияОчередьИзменений.СоздатьМенеджерЗаписи();
		//МенЗаписи.ПредметСнабжения = Объект.ПредметСнабжения;
		//МенЗаписи.Период = ТекущаяДата();
		//МенЗаписи.Записать();
		//
		////++ 17.04.2018 Веденеев П. //устранение бага с добавлением в очередь пустых предметов снабжения
		//Если ЗначениеЗаполнено(Объект.Родитель) И Не Объект.Родитель.Тип = Справочники.ТипыУзловЭлектроннойСтруктурыКомплектующихИзделийИЗИПКорабля.Группа Тогда
		//		
		//	МенЗаписи = РегистрыСведений.СпецификацииПредметовСнабженияОчередьИзменений.СоздатьМенеджерЗаписи();
		//	МенЗаписи.ПредметСнабжения = Объект.Родитель.ПредметСнабжения;
		//	МенЗаписи.Период = ТекущаяДата();
		//	МенЗаписи.Записать();
		//	
		//КонецЕсли; 
		
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьВидимостьКоличествЗИП();
	
	//++ 12.04.2018 Веденеев П. //установка параметров динамических списков
	РегламентТОиРТекущиеДанные = Элементы.РегламентТОиР.ТекущиеДанные;	
	СписокЗИПдляТОиР.Параметры.УстановитьЗначениеПараметра("ВидРабот", ?(РегламентТОиРТекущиеДанные = Неопределено, Неопределено, РегламентТОиРТекущиеДанные.ВидРабот));
	//-- 12.04.2018 Веденеев П. //установка параметров динамических списков
	
КонецПроцедуры

//+++ 14.02.2018 Тычина Р.В. // Нельзя снимать галочку ЗИП, когда изделие входит в свой же состав, иначе произойдет зацикливание 
&НаСервере
Функция МожноИзменитьЗИП()
	
	Возврат НЕ (Объект.Родитель.ПредметСнабжения = Объект.ПредметСнабжения И НЕ Объект.ЗИП);
	
КонецФункции
//--- 14.02.2018 Тычина Р.В. // Нельзя снимать галочку ЗИП, когда изделие входит в свой же состав, иначе произойдет зацикливание

//++ 19.02.2018 Веденеев П. //если установлен флаг ЗИП, но предмет снабжения имеет спецификацию - запрашиваем подтверждение действия
&НаСервереБезКонтекста
Функция ИмеетсяСпецификация(ПредметСнабжения)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	СпецификацииПредметовСнабжения.СоставляющаяЧасть КАК СоставляющаяЧасть
	|ИЗ
	|	РегистрСведений.СпецификацииПредметовСнабжения КАК СпецификацииПредметовСнабжения
	|ГДЕ
	|	СпецификацииПредметовСнабжения.ПредметСнабжения = &ПредметСнабжения";
	Запрос.УстановитьПараметр("ПредметСнабжения", ПредметСнабжения);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат Не РезультатЗапроса.Пустой();
	
КонецФункции

&НаКлиенте
Процедура ПриИзмененииЗИП(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		
		УстановитьВидимостьКоличествЗИП();
		
		Элементы.ГруппаЭкземпляры.Видимость = Не Объект.ЗИП И ЗначениеЗаполнено(Объект.Ссылка); //++ 19.01.18 Веденеев П. //закладка Экземпляры доступна только для комплектующих изделий
		
		Если Объект.ЗИП Тогда
			
			Элементы.ГруппаХранение.Видимость = Истина;	
			
		Иначе
			
			Элементы.ГруппаХранение.Видимость = Ложь;
			Объект.Помещение 		= ПредопределенноеЗначение("Справочник.Помещения.ПустаяСсылка");
			Объект.МестоХранения 	= "";
			
		КонецЕсли;
		
	Иначе
		
		Объект.ЗИП = Ложь;
		Сообщить("Действие отменено!");
		
	КонецЕсли;	
	
КонецПроцедуры
//-- 19.02.2018 Веденеев П. //если установлен флаг ЗИП, но предмет снабжения имеет спецификацию - запрашиваем подтверждение действия

&НаКлиенте
Процедура ЗИППриИзменении(Элемент)
	
////+++ 14.02.2018 Тычина Р.В. // Нельзя снимать галочку ЗИП, когда изделие входит в свой же состав, иначе произойдет зацикливание 
//	Если НЕ МожноИзменитьЗИП() Тогда
//		
//		Объект.ЗИП = Истина;
//		
//		Сообщить("Нельзя убрать галочку ЗИП, т.к. изделие входит в состав самого себя!",СтатусСообщения.Внимание);
//		
//	КонецЕсли; 
////--- 14.02.2018 Тычина Р.В. // Нельзя снимать галочку ЗИП, когда изделие входит в свой же состав, иначе произойдет зацикливание

//	//++ 19.02.2018 Веденеев П. //если установлен флаг ЗИП, но предмет снабжения имеет спецификацию - запрашиваем подтверждение действия
//	Если Объект.ЗИП И ИмеетсяСпецификация(Объект.ПредметСнабжения) Тогда
//		
//		ПоказатьВопрос(Новый ОписаниеОповещения("ПриИзмененииЗИП", ЭтаФорма), 
//			"Спецификация элемента будет удалена из структуры заказа (включая данные о количестве). Продолжить?", РежимДиалогаВопрос.ДаНет);
//		
//	Иначе
//		
//		ПриИзмененииЗИП(КодВозвратаДиалога.Да, Неопределено);
//		
//	КонецЕсли;
//	//-- 19.02.2018 Веденеев П. //если установлен флаг ЗИП, но предмет снабжения имеет спецификацию - запрашиваем подтверждение действия
//	

	УстановитьВидимостьКоличествЗИП();

	Элементы.ГруппаЭкземпляры.Видимость = Не Объект.ЗИП И ЗначениеЗаполнено(Объект.Ссылка); 

	Если Объект.ЗИП Тогда
		
		Элементы.ГруппаХранение.Видимость = Истина;	
		
	Иначе
		
		Элементы.ГруппаХранение.Видимость = Ложь;
		Объект.Помещение 		= ПредопределенноеЗначение("Справочник.Помещения.ПустаяСсылка");
		Объект.МестоХранения 	= "";
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьКоличествЗИП()

	Элементы.ГруппаКоличествоВЗИП.Видимость = Объект.ЗИП;	

КонецПроцедуры // УстановитьВидимостьКоличествЗИП()

&НаКлиенте
Процедура ПоказатьВСписке(Команда)
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
	
		ПараметрыОткрытия = Новый Структура();
		ПараметрыОткрытия.Вставить("ЭлементСтруктуры", Объект.Ссылка);
		ПараметрыОткрытия.Вставить("Владелец", Объект.Владелец);
		
		ОткрытьФорму("Справочник.СтруктураЗаказаПоКомплектующимИзделиямИЗИП.ФормаСписка", ПараметрыОткрытия, ЭтотОбъект);
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаведованиеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("Владелец", Объект.Владелец);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикВыбораЗаведования", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.БоевыеЧасти.ФормаВыбора", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораЗаведования(Заведование, ДопПараметры = Неопределено) Экспорт

	Если ЗначениеЗаполнено(Заведование) Тогда
	
		Объект.Заведование = Заведование;
		Модифицированность = Истина;
	
	КонецЕсли;	

КонецПроцедуры // ОбработчикВыбораЗаведования()

&НаКлиенте
Процедура ЗаведованиеСоздание(Элемент, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ПараметрыОткрытия = Новый Структура("Владелец", Объект.Владелец);
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ОбработчикВыбораЗаведования", ЭтотОбъект);
	
	ОткрытьФорму("Справочник.БоевыеЧасти.ФормаОбъекта", ПараметрыОткрытия, ЭтотОбъект,,,, ОписаниеОповещения, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущееИзображение(Команда)
	
	НомерТекущегоИзображения = НомерТекущегоИзображения - 1;
	
	АдресКартинки = Изображения.Получить(НомерТекущегоИзображения).Значение;
	
	Элементы.ПредыдущееИзображение.Доступность = НомерТекущегоИзображения > 0;
	Элементы.СледующееИзображение.Доступность = Истина;
	
КонецПроцедуры

&НаКлиенте
Процедура СледующееИзображение(Команда)
	
	НомерТекущегоИзображения = НомерТекущегоИзображения + 1;
	
	АдресКартинки = Изображения.Получить(НомерТекущегоИзображения).Значение;
	
	Элементы.ПредыдущееИзображение.Доступность = Истина;
	Элементы.СледующееИзображение.Доступность = КоличествоИзображений > НомерТекущегоИзображения + 1;
		
КонецПроцедуры

&НаКлиенте
Процедура ВНижнийРегистр(Команда)
	Элементы.НаименованиеДополнительное.ВыделенныйТекст = НРЕГ(Элементы.НаименованиеДополнительное.ВыделенныйТекст);
КонецПроцедуры

&НаКлиенте
Процедура ВВерхнийРегистр(Команда)
	Элементы.НаименованиеДополнительное.ВыделенныйТекст = ВРег(Элементы.НаименованиеДополнительное.ВыделенныйТекст);
КонецПроцедуры

//++ 22.01.2018 Веденеев П. //процедуры и функции работы с экземплярами элемента структуры

&НаКлиенте
Процедура ЭкземплярыКомплектующегоИзделияПриАктивизацииСтроки(Элемент)
	
	ТекущиеДанные = Элементы.ЭкземплярыКомплектующегоИзделия.ТекущиеДанные;
	
	ЗначениеОтбора = ?(ТекущиеДанные = Неопределено, ЭкземплярПустаяСсылка, ТекущиеДанные.Ссылка);
	
	ИсторияТОиР.Отбор.Элементы[0].ПравоеЗначение = ЗначениеОтбора;
	Наработка.Отбор.Элементы[0].ПравоеЗначение = ЗначениеОтбора;
	
	ГруппаОтбора = СвязанныеИзделия.Отбор.Элементы[0];
	ГруппаОтбора.Элементы[0].ПравоеЗначение = ЗначениеОтбора;
	ГруппаОтбора.Элементы[1].ПравоеЗначение = ЗначениеОтбора;
	
	ЗаполнитьУчетРесурсовИСроковСлужбы();
		
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСвязанноеИзделие(Команда)
	
	ТекущиеДанныеЭкземпляры = Элементы.ЭкземплярыКомплектующегоИзделия.ТекущиеДанные;
	
	Если Не ТекущиеДанныеЭкземпляры = Неопределено Тогда
		
		ПараметрыОткрытия = Новый Структура("Экземпляр", ТекущиеДанныеЭкземпляры.Ссылка); 
		
		ОткрытьФорму("РегистрСведений.СвязанныеИзделияЭкземпляровКомплектующихИзделийКорабля.ФормаЗаписи", ПараметрыОткрытия, ЭтаФорма,
		, , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьУчетРесурсовИСроковСлужбы()
	
	ТекущиеДанные = Элементы.ЭкземплярыКомплектующегоИзделия.ТекущиеДанные;
	
	Если ТекущиеДанные = Неопределено Тогда
		
		УчетРесурсовИСроковСлужбы.Очистить();
		
	Иначе
		
		ТаблицаУчета = УчетРесурсовИСроковСлужбы;
		ЗаполнитьУчетРесурсовИСроковСлужбыСервер(ТекущиеДанные.Ссылка, ТаблицаУчета);
		КопироватьДанныеФормы(ТаблицаУчета, УчетРесурсовИСроковСлужбы);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗаполнитьУчетРесурсовИСроковСлужбыСервер(Экземпляр, ТаблицаУчета)
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВложенныйЗапрос.Показатель КАК Показатель,
	|	ВложенныйЗапрос.ПараметрУчета КАК ПараметрУчета,
	|	ВложенныйЗапрос.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.НормативноеЗначение) КАК НормативноеЗначение,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.ЗначениеСНачалаЭксплуатации) КАК ЗначениеСНачалаЭксплуатации,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.ЗначениеСУчетомРемонта) КАК ЗначениеСУчетомРемонта,
	|	ПРЕДСТАВЛЕНИЕ(ВЫБОР
	|			КОГДА ВложенныйЗапрос.НормативноеЗначение < ВложенныйЗапрос.ЗначениеСУчетомРемонта
	|				ТОГДА 0
	|			ИНАЧЕ ВложенныйЗапрос.НормативноеЗначение - ВложенныйЗапрос.ЗначениеСУчетомРемонта
	|		КОНЕЦ) КАК ОстатокДоНорматива,
	|	ПРЕДСТАВЛЕНИЕ(ВложенныйЗапрос.ДатаЗначения) КАК ДатаЗначения
	|ИЗ
	|	(ВЫБРАТЬ
	|		РесурсыИСрокиСлужбы.Показатель КАК Показатель,
	|		РесурсыИСрокиСлужбы.ПараметрУчета КАК ПараметрУчета,
	|		РесурсыИСрокиСлужбы.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|		РесурсыИСрокиСлужбы.Значение КАК НормативноеЗначение,
	|		ВЫБОР
	|			КОГДА РесурсыИСрокиСлужбы.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателей.ПоСроку)
	|				ТОГДА РАЗНОСТЬДАТ(&ДатаВвода, &Дата, ДЕНЬ)
	|			ИНАЧЕ ЕСТЬNULL(Наработка.ЗначениеСНачалаЭксплуатации, 0)
	|		КОНЕЦ КАК ЗначениеСНачалаЭксплуатации,
	|		ВЫБОР
	|			КОГДА РесурсыИСрокиСлужбы.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателей.ПоСроку)
	|				ТОГДА ВЫБОР
	|						КОГДА РесурсыИСрокиСлужбы.УчетРемонтов
	|							ТОГДА РАЗНОСТЬДАТ(ЕСТЬNULL(ИнформацияОРемонте.Период, &ДатаВвода), &Дата, ДЕНЬ)
	|						ИНАЧЕ РАЗНОСТЬДАТ(&ДатаВвода, &Дата, ДЕНЬ)
	|					КОНЕЦ
	|			ИНАЧЕ ВЫБОР
	|					КОГДА РесурсыИСрокиСлужбы.УчетРемонтов
	|						ТОГДА ЕСТЬNULL(Наработка.ЗначениеСНачалаЭксплуатации, 0) - ЕСТЬNULL(ИнформацияОРемонте.ЗначениеСНачалаЭксплуатации, 0)
	|					ИНАЧЕ ЕСТЬNULL(Наработка.ЗначениеСНачалаЭксплуатации, 0)
	|				КОНЕЦ
	|		КОНЕЦ КАК ЗначениеСУчетомРемонта,
	|		ВЫБОР
	|			КОГДА РесурсыИСрокиСлужбы.ТипПоказателя = ЗНАЧЕНИЕ(Перечисление.ТипыПоказателей.ПоСроку)
	|				ТОГДА &Дата
	|			ИНАЧЕ ЕСТЬNULL(Наработка.Период, &ДатаВвода)
	|		КОНЕЦ КАК ДатаЗначения
	|	ИЗ
	|		(ВЫБРАТЬ
	|			РесурсыИСрокиСлужбыПредметовСнабжения.Показатель КАК Показатель,
	|			РесурсыИСрокиСлужбыПредметовСнабжения.ПараметрУчета КАК ПараметрУчета,
	|			РесурсыИСрокиСлужбыПредметовСнабжения.Значение КАК Значение,
	|			РесурсыИСрокиСлужбыПредметовСнабжения.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
	|			ТипыПоказателейИзделий.ТипПоказателя КАК ТипПоказателя,
	|			ТипыПоказателейИзделий.УчетРемонтов КАК УчетРемонтов
	|		ИЗ
	|			РегистрСведений.РесурсыИСрокиСлужбыПредметовСнабжения КАК РесурсыИСрокиСлужбыПредметовСнабжения
	|				ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ТипыПоказателейИзделий КАК ТипыПоказателейИзделий
	|				ПО РесурсыИСрокиСлужбыПредметовСнабжения.Показатель = ТипыПоказателейИзделий.Ссылка
	|		ГДЕ
	|			РесурсыИСрокиСлужбыПредметовСнабжения.ПредметСнабжения = &ПредметСнабжения) КАК РесурсыИСрокиСлужбы
	|			ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|				НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.ПараметрУчета КАК ПараметрУчета,
	|				МАКСИМУМ(НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.ЗначениеСНачалаЭксплуатации) КАК ЗначениеСНачалаЭксплуатации,
	|				МАКСИМУМ(НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.Период) КАК Период
	|			ИЗ
	|				РегистрСведений.НаработкаЭкземляровКомплектующихИзделийКорабля.СрезПоследних(&Дата, Экземпляр = &Экземпляр) КАК НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних
	|			
	|			СГРУППИРОВАТЬ ПО
	|				НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.ПараметрУчета) КАК Наработка
	|				ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	|					НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.ПараметрУчета КАК ПараметрУчета,
	|					НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.Период КАК Период,
	|					НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних.ЗначениеСНачалаЭксплуатации КАК ЗначениеСНачалаЭксплуатации
	|				ИЗ
	|					РегистрСведений.НаработкаЭкземляровКомплектующихИзделийКорабля.СрезПоследних(
	|							&Дата,
	|							Экземпляр = &Экземпляр
	|								И НачалоЦикла) КАК НаработкаЭкземляровКомплектующихИзделийКорабляСрезПоследних) КАК ИнформацияОРемонте
	|				ПО Наработка.ПараметрУчета = ИнформацияОРемонте.ПараметрУчета
	|			ПО РесурсыИСрокиСлужбы.ПараметрУчета = Наработка.ПараметрУчета) КАК ВложенныйЗапрос
	|
	|УПОРЯДОЧИТЬ ПО
	|	ПараметрУчета,
	|	Показатель";
	
	ТекДата = ТекущаяДата();
	ДатаВвода = ?(ЗначениеЗаполнено(Экземпляр.ДатаВвода), Экземпляр.ДатаВвода, ТекДата);
	
	Запрос.УстановитьПараметр("Экземпляр", Экземпляр);
	Запрос.УстановитьПараметр("ПредметСнабжения", Экземпляр.Владелец.ПредметСнабжения);
	Запрос.УстановитьПараметр("Дата", ТекДата);
	Запрос.УстановитьПараметр("ДатаВвода", ДатаВвода);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Если РезультатЗапроса.Пустой() Тогда
		
		ТаблицаУчета.Очистить();
		
	Иначе
		
		ТаблицаУчета.Загрузить(РезультатЗапроса.Выгрузить());
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьИнформацию(Команда)
	
	ЗаполнитьУчетРесурсовИСроковСлужбы();
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыИнформацияПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	Если Элементы.ГруппаСтраницыИнформация.ТекущаяСтраница = Элементы.ГруппаУчетРесурсовИСроковСлужбы Тогда
		
		ЗаполнитьУчетРесурсовИСроковСлужбы();
		
	Иначе
		
		УчетРесурсовИСроковСлужбы.Очистить();
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЗакладкиЭкземпляры()
	
	ТипОтбора = Тип("ЭлементОтбораКомпоновкиДанных");
	
	//отбор списка экземпляров
	ОтборЭкземпляров = ЭкземплярыКомплектующегоИзделия.Отбор;
	ОтборЭкземпляров.Элементы.Очистить();
	
	ЭлементОтбораЭкземпляров = ОтборЭкземпляров.Элементы.Добавить(ТипОтбора);
	ЭлементОтбораЭкземпляров.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	ЭлементОтбораЭкземпляров.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораЭкземпляров.ПравоеЗначение = Объект.Ссылка;
	
	//отбор истории ТО и Р
	ОтборИсторииТОиР = ИсторияТОиР.Отбор;
	ОтборИсторииТОиР.Элементы.Очистить();
	
	ЭлементОтбораИсторииТОиР = ОтборИсторииТОиР.Элементы.Добавить(ТипОтбора);
	ЭлементОтбораИсторииТОиР.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Экземпляр");
	ЭлементОтбораИсторииТОиР.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораИсторииТОиР.ПравоеЗначение = ЭкземплярПустаяСсылка;
	
	//отбор списка наработок
	ОтборНаработки = Наработка.Отбор;
	ОтборНаработки.Элементы.Очистить();
	
	ЭлементОтбораНаработки = ОтборНаработки.Элементы.Добавить(ТипОтбора);
	ЭлементОтбораНаработки.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Экземпляр");
	ЭлементОтбораНаработки.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораНаработки.ПравоеЗначение = ЭкземплярПустаяСсылка;
	
	//отбор списка связанных изделий
	ОтборСвязанныхИзделий = СвязанныеИзделия.Отбор;
	ОтборСвязанныхИзделий.Элементы.Очистить();
	
	ГруппаОтбора = ОтборСвязанныхИзделий.Элементы.Добавить(Тип("ГруппаЭлементовОтбораКомпоновкиДанных"));
	ГруппаОтбора.ТипГруппы = ТипГруппыЭлементовОтбораКомпоновкиДанных.ГруппаИли;
	
	ЭлементОтбораСвязанныхИзделий = ГруппаОтбора.Элементы.Добавить(ТипОтбора);
	ЭлементОтбораСвязанныхИзделий.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Экземпляр");
	ЭлементОтбораСвязанныхИзделий.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораСвязанныхИзделий.ПравоеЗначение = ЭкземплярПустаяСсылка;
	
	ЭлементОтбораСвязанныхИзделий = ГруппаОтбора.Элементы.Добавить(ТипОтбора);
	ЭлементОтбораСвязанныхИзделий.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("СвязанноеИзделие");
	ЭлементОтбораСвязанныхИзделий.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбораСвязанныхИзделий.ПравоеЗначение = ЭкземплярПустаяСсылка;
	
	//заменяем стандартную команду для возможности установить значение экземпляра не через отбор
	Если Не Элементы.СвязанныеИзделия.КоманднаяПанель.ПодчиненныеЭлементы.Найти("СвязанныеИзделияСоздать") = Неопределено Тогда
	
		Элементы.СвязанныеИзделия.КоманднаяПанель.ПодчиненныеЭлементы.СвязанныеИзделияСоздать.ИмяКоманды = "СоздатьСвязанноеИзделие";
		
	КонецЕсли;
	
КонецПроцедуры
//-- 22.01.2018 Веденеев П. //процедуры и функции работы с экземплярами элемента структуры

//++ 12.04.2018 Веденеев П. //кнопка открытия предмета снабжения + вкладки с информацией о предмете снабжения
&НаКлиенте
Процедура ОткрытьПредметСнабжения(Команда)
	
	Если ЗначениеЗаполнено(Объект.ПредметСнабжения) Тогда
		
		ПоказатьЗначение(, Объект.ПредметСнабжения);
		
	Иначе
		
		Сообщить("Предмет снабжения не указан!");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПереводПравилУпаковки(Команда)
	
	Если Не ЗначениеЗаполнено(Объект.ПредметСнабжения) Тогда
	
		ПоказатьПредупреждение(, "Для работы с переводом необходимо указать предмет снабжения",, "Действие запрещено");
		Возврат;
	
	КонецЕсли;
	
	ПараметрыОткрытия = Новый Структура();
	ПараметрыОткрытия.Вставить("Владелец", Объект.ПредметСнабжения);
	ПараметрыОткрытия.Вставить("ИмяРеквизита", "ПравилаУпаковкиТранспортировкиХранения");
	ПараметрыОткрытия.Вставить("Значение", ПолучитьСвойствоПредметаСнабжения(Объект.ПредметСнабжения, "ПравилаУпаковкиТранспортировкиХранения"));
	
	ОткрытьФорму("ОбщаяФорма.Перевод", ПараметрыОткрытия, ЭтотОбъект, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСвойствоПредметаСнабжения(ПредметСнабжения, ИмяСвойства)
	
	Возврат ПредметСнабжения[ИмяСвойства]; 
	
КонецФункции


&НаКлиенте
Процедура РегламентТОиРПриАктивизацииСтроки(Элемент)
	
	РегламентТОиРТекущиеДанные = Элементы.РегламентТОиР.ТекущиеДанные;	
	СписокЗИПдляТОиР.Параметры.УстановитьЗначениеПараметра("ВидРабот", ?(РегламентТОиРТекущиеДанные = Неопределено, Неопределено, РегламентТОиРТекущиеДанные.ВидРабот));
	
КонецПроцедуры


&НаКлиенте
Процедура ПредметСнабженияПриИзменении(Элемент)
	ЗаполнитьICAT();
КонецПроцедуры // ПредметСнабженияПриИзменении



//-- 12.04.2018 Веденеев П. //кнопка открытия предмета снабжения + вкладки с информацией о предмете снабжения
