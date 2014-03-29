SRC_DIR = src
TOP_OBJ_DIR = bin

ifeq ($(MODE),)
	MODE = debug
endif

SRCS = \
	main.cpp

TARGET = rtlp

.PHONY: all clean

all: target

clean:
	rm -rf $(TOP_OBJ_DIR) $(TARGET)

CURR_DIR = $(shell pwd)

CXX = g++
CXXFLAGS += -Wall -ansi -pedantic -I"$(CURR_DIR)/include" -I"$(CURR_DIR)/$(SRC_DIR)" -I /usr/local/boost_1_55_0
LDFLAGS = -L"$(CURR_DIR)/lib"

ifeq ($(MODE), release)
	SUB_OBJ_DIR = release
	CXXFLAGS += -O2
else ifeq ($(MODE), debug)
	SUB_OBJ_DIR = debug
	CXXFLAGS += -g -O0
else
ERRORMSG = "unknown build mode: $(MODE)"
endif

OBJ_DIR = $(TOP_OBJ_DIR)/$(SUB_OBJ_DIR)

OBJS = $(SRCS:.cpp=.o)
DEPS = $(OBJS:.o=.d)
OBJS_FULL = $(addprefix $(OBJ_DIR)/,$(OBJS))
DEPS_FULL = $(addprefix $(OBJ_DIR)/,$(DEPS))

.PHONY: target

ifneq ($(ERRORMSG),)
target:
	$(error $(ERRORMSG))
else
target: $(OBJ_DIR)/$(TARGET).exe
	cp $< $(TARGET)

$(OBJ_DIR)/%.d: $(SRC_DIR)/%.cpp
	mkdir -p $(@D)
	$(CXX) $(CXXFLAGS) -MM -MP -MT $(@:.d=.o) -o $@ $<

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

ifneq ($(MAKECMDGOALS),clean)
-include $(DEPS_FULL)
endif

$(OBJ_DIR)/$(TARGET).exe: $(OBJS_FULL)
	$(CXX) $(CXXFLAGS) -o $@ $^ $(LDFLAGS)
endif
