# indicate activation of a virtual environment 
show_virtual_env() {
  if [[ -n "$VIRTUAL_ENV" && -n "$DIRENV_DIR" ]]; then
	  echo "($(basename ${DIRENV_DIR:1}))"
  fi
}
