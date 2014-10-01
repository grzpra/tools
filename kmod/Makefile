CROSS_COMPILE?=
ARCH?=x86
KDIR?=/lib/modules/$(shell uname -r)/build

MODULE_NAME=module

obj-m=$(MODULE_NAME).o

TEST_DIR=tst
TEST_OBJECTS=$(patsubst %.c,%.o,$(wildcard $(TEST_DIR)/*.c))
TEST_LDFLAGS=
TEST_CFLAGS=-I $(CURDIR) -I $(TEST_DIR)

all: module test

module:
	@$(MAKE) ARCH=$(ARCH) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(CURDIR) modules

test: $(TEST_OBJECTS)
	@echo " [LD] $?"
	@$(CROSS_COMPILE)gcc $^ -o $(MODULE_NAME)_test $(TEST_LDFLAGS)

$(TEST_DIR)/%.o: $(TEST_DIR)/%.c
	@echo " [CC] $?"
	@$(CROSS_COMPILE)gcc $< -o $@ -c $(TEST_CFLAGS)

clean:
	@$(RM) $(TEST_DIR)/*.o $(MODULE_NAME)_test
	@$(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) -C $(KDIR) M=$(CURDIR) clean
