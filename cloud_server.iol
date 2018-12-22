type LoadRequest:void {
  .program:string
}

interface CloudServerIface {
RequestResponse:
  status(void)(undefined),
  health(void)(string)
OneWay:
  unload(void)
}
