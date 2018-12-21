include "runtime.iol"
include "file.iol"
include "cloud_server.iol"
include "console.iol"
include "time.iol"
include "jolie_deployer_interface.iol"
include "exec.iol"
include "string_utils.iol"
include "service-mesh.iol"


inputPort CloudServer {
Location: "socket://localhost:8000/"
Protocol: http {.format = "raw"}
Interfaces: CloudServerIface,
            ServiceMeshInterface
}


outputPort Jolie_Deployer {
Location: "socket://jolie-deployer:8000/"
//Location: "socket://localhost:8000/"
Protocol: http
Interfaces: User_Service_Interface
}


execution { sequential }


init
{
    
    println@Console("Doing init")();
    exec@Exec("printenv TOKEN")(res);
    token = string(res);




    length@StringUtils(token)(len);
    println@Console("length of token is: " + len)();

    substr = token;
    substr.begin = 0;
    substr.end = 36;
    substring@StringUtils(substr)(answer);

    //get the program from the jolie-deployer
    getProgram@Jolie_Deployer(answer)(program);

    println@Console("Finished getting the program: \n" + program)();


    
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



main
{
    
  
  [status()(response){
      stats@Runtime()(state);
      response = "Available processors: " + state.os.availableProcessors + 
                 ", System load average: " + state.os.systemLoadAverage
  }
  
  ]
  
  [ health() ( resp ) {
      resp = "Service alive and reachable"
  }]
  
  
  [unload()(answer){
      //TODO unregister service from consul
      
      //we could possibly stop the program here, but 
      //jolie documentation is so awful, I don't know 
      //how to do that. callExit@Runtime or halt@Runtime...
      
      
      answer = "OK to undeploy me."
      }]
}

