#!/bin/sh


$_SRC_DIR/.presets/dev/init.sh
$_SRC_DIR/.presets/jupyter/init.sh

poetry add pandas "mlflow[extras]"
