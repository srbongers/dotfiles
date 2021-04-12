if [ -f "/home/srbongers/.miniconda/etc/profile.d/conda.sh" ]; then
    . "/home/srbongers/.miniconda/etc/profile.d/conda.sh"
    CONDA_CHANGEPS1=false conda activate jupyter-base
    export DISPLAY=:1
    xvfb-run -n 1 -s "-screen 0 1400x900x24" jupyter lab --no-browser --config=/home/srbongers/.jupyter/jupyter_server_config.py
fi
