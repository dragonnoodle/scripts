#compile option
CXX	:= g++
CC	:= gcc
OPT	:= -g -O0 -ggdb -Wall -Wno-deprecated -Wno-unused-function -Wno-unused-variable
AR	:= ar rc

#head file and lib file
LIBDIRS	:= #../taxi/src/thirdparty/protobuf/lib
LIBS	:= #protobuf
INCDIRS	:= ../taxi/src/thirdparty/json-c/include
STLIBS	:= \
	../taxi/src/thirdparty/json-c/lib/libjson-c.a

#define macro
MACROS	:=

#files should be solved
SRCDIRS	:= . 
SRCEXTS	:= .cpp .cc .cxx
SRCS	:=

#target
TYPE	:= exe#(exe lib dll)
TARGET	:= main

#config end
###############################################################################################################
#calc var

ifeq ($(TYPE),dll) 
	OPT += -fPIC -shared
endif 

SOURSES	:= $(foreach d, $(SRCDIRS), $(wildcard $(addprefix $(d)/*, $(SRCEXTS))))
SOURSES	+= $(SRCS)
OBJS	:= $(foreach x, $(SRCEXTS), $(patsubst %$(x), %.o, $(filter %$(x), $(SOURSES))))

LIBDIROPT	:= $(foreach d,$(LIBDIRS),-L$(d))
LIBOPT		:= $(foreach f,$(LIBS),-l$(f))
INCOPT		:= $(foreach d,$(SRCDIRS),-I$(d))
INCOPT		+= $(foreach d,$(INCDIRS),-I$(d))

#calc var end
###############################################################################################################
all: $(TARGET)
$(TARGET):$(OBJS)
ifeq ("$(TYPE)","lib")
	$(AR) $(TARGET) $^
else
	$(CXX) $(OPT) -o $(TARGET) $^ $(LIBDIROPT) $(LIBOPT) $(STLIBS)
endif

%.o:%.c
	$(CC) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cpp
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cc
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)
%.o:%.cxx
	$(CXX) $(OPT) -c $< -o $@ $(INCOPT)

clean:
	rm -rf $(OBJS) $(TARGET)
################################################################################################################


#Copyright (c) 2017 xiethon126.com
#
#Makefile示例

# $(notdir $(CURDIR)) 获取目录名，notdir:Make函数
TARGET = $(notdir $(CURDIR)) 

CROSS_COMPILE = gcc
COMPILE.c = $(CROSS_COMPILE)  -c
LINK.c = $(CROSS_COMPILE)
RM =rm

# $(wildcard src/*.c) ：获取src/ 目录下的所有.c文件。wildcard:Make函数
SOURCES = $(wildcard src/*.c)
HEADERS = $(wildcard inc/*.h)

# 静态模式规则。OBJFILES下的所有.c 替换成 .o文件
OBJFILES = $(SOURCES:%.c=%.o)


.PHONY:clean all install

all:$(TARGET) 
	@echo builded target:$^
	@echo 
$(TARGET): $(OBJFILES) 
	@echo 
	@echo Linking $@ from $^...
	$(LINK.c) -o $@ $^ 
	@echo Link finished

$(OBJFILES): %.o:%.c $(HEADERS)
	@echo
	@echo Compiling $@ from $<...
	$(COMPILE.c) -o $@ $<
	@echo Compile finished

clean:
	@echo Removing generated files...
	@ -$(RM) -rf $(OBJFILES) $(TARGET) $(EXEC_DIR) *~ *.d *.o 

