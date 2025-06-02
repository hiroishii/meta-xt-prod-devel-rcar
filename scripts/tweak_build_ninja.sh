#!/bin/bash

# workaround: Modify build.ninja to inherit rm_work, since moulin seems not to be able to handle "+=" syntax
# Also, we'd apply RM_WORK_EXCLUDE for some of the tasks to avoid build error caused by referreing to the intermediate files in the work directories
sed -i -e "s/conf\ =\ /conf\ =\ \
    \'INHERIT\ \+\=\ \"rm_work\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" xen\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" xen-tools\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" u-boot\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" arm-trusted-firmware\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" linux-renesas\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" linux-generic-armv8\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" core-image-weston\"\'\ \
    \'RM_WORK_EXCLUDE\ \+\=\ \" core-image-thin-initramfs\"\'\ \
    /g" build.ninja
