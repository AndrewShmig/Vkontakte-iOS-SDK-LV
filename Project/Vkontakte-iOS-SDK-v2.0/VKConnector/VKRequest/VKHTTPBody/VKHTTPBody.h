//
// Created by AndrewShmig on 7/10/13.
//
// Copyright (c) 2013 Andrew Shmig
// 
// Permission is hereby granted, free of charge, to any person 
// obtaining a copy of this software and associated documentation 
// files (the "Software"), to deal in the Software without 
// restriction, including without limitation the rights to use, 
// copy, modify, merge, publish, distribute, sublicense, and/or 
// sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following 
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES 
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
// FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
// OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN 
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN 
// THE SOFTWARE.
//
#import <Foundation/Foundation.h>

/** Класс предназначен для создания тела запроса при отправке на сервер социальной
сети ВКонтакте аудио, видео, изображений и документов.

В частности класс предназначен для решения проблемы отправки нескольких файлов
на сервера ВК.

Дополнительная информация о формировании тела POST запроса может быть найдена по
следующим ссылкам:

1. http://www.ietf.org/rfc/rfc1867.txt
2. http://ru.wikipedia.org/wiki/HTTP (Раздел: Множественное содержимое)
3. http://www.ntu.edu.sg/home/ehchua/programming/webprogramming/HTTP_Basics.html

*/
@interface VKHTTPBody : NSObject

/**
@name Свойства
*/
/** Байтовое представление данных
*/
@property (nonatomic, strong, readonly) NSData *data;

/** Строка "граница" между данными
*/
@property (nonatomic, strong, readonly) NSString *boundary;

/**
@name Добавление объекта
*/
/** Добавление данных аудио файла в содержимое тела HTTP запроса

@param file байтовое представление аудио файла
@param name имя аудио файла
@param field наименования HTML поля, которое использовалось для отправки файла
*/
- (void)appendAudioFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Добавление данных видео файла в содержимое тела HTTP запроса

@param file байтовое представление видео файла
@param name имя видео файла
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendVideoFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

/** Добавление данных документа в содержимое тела HTTP запроса

@param file байтовое представление документа
@param name имя файла документа
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendDocumentFile:(NSData *)file
                      name:(NSString *)name
                     field:(NSString *)field;

/** Добавление данных изображения в содержимое тела HTTP запроса

@param file байтовое представление изображения
@param name имя файла изображения
@param field наименование HTML поля, которое использовалось для отправки файла
*/
- (void)appendImageFile:(NSData *)file
                   name:(NSString *)name
                  field:(NSString *)field;

@end