include "runtime.iol"
include "file.iol"
include "cloud_server.iol"
include "console.iol"
include "time.iol"
include "jolie_deployer_interface.iol"
include "exec.iol"
include "string_utils.iol"

inputPort CloudServer {
    Location: "socket://localhost:8000/"
    Protocol: http {.format = "raw"}
    Interfaces: CloudServerIface
}

outputPort Jolie_Deployer {
    Location: "socket://jolie-deployer:8000/"
    Protocol: http
    Interfaces: User_Service_Interface
}

execution { sequential }

define configureServiceDefinition
{
    getenv@Runtime("TOKEN")(token);
    getenv@Runtime("USER_ID")(userID);
    exec@Exec("consulctl service --name=deployment" + token)();
    exec@Exec("consulctl service --add-tag=token:" + token)();
    exec@Exec("consulctl service --add-tag=user_id:" + userID)()
}

define registerService
{
    exec@Exec("consulctl service --register")()
}

define deregisterService
{
    exec@Exec("consulctl service --deregister")()
}

define downloadUserScript
{
    getenv@Runtime("TOKEN")(token);
    length@StringUtils(token)(len);
    println@Console("length of token is: " + len)();

    substr = token;
    substr.begin = 0;
    substr.end = 36;
    substring@StringUtils(substr)(answer);

    //get the program from the jolie-deployer
    getProgram@Jolie_Deployer(answer)(program);

    println@Console("Finished getting the program: \n" + program)()
}

define loadUserScript
{
    user_program_name = "user_prog";
    filename = user_program_name + ".ol";
    writeFile@File( {
      .content = program,
      .filename = filename
    } )();
    install( RuntimeException =>
      println@Console( main.RuntimeException.stackTrace )()
    );
    loadEmbeddedService@Runtime( {
      .type = "Jolie",
      .filepath = filename
    } )( location );

    println@Console( "loaded service.")()
}

init
{
    println@Console("Initialising..")();

    downloadUserScript;
    loadUserScript;
    configureServiceDefinition;
    registerService
}

main
{
  [status()(response){
      stats@Runtime()(state);
      response = "Available processors: " + state.os.availableProcessors + 
                 ", System load average: " + state.os.systemLoadAverage
  }]
  
  [ health() ( resp ) {
      resp = "Service alive and reachable"
  }]

  [unload ()] {
      //TODO unregister service from consul
      
      println@Console("Unloading my service")();
      //we could possibly stop the program here, but 
      //jolie documentation is so awful, I don't know 
      //how to do that. callExit@Runtime or halt@Runtime...
      
      deregisterService
  }
}

