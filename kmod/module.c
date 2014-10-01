#include <linux/module.h>

#include "module.h"

static int __init hello_start(void)
{
	printk("%s loaded.\n", DRIVER_DESC);

	return 0;
}

static void __exit hello_end(void)
{
	printk("%s unloaded.\n", DRIVER_DESC);
}

module_init(hello_start);
module_exit(hello_end);


MODULE_LICENSE("GPL");
MODULE_AUTHOR(DRIVER_AUTHOR);
MODULE_DESCRIPTION(DRIVER_DESC);
