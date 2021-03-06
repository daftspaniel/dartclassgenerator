import 'package:web_ui/web_ui.dart';
import 'dart:html';

/***
 * Control that acts as a simple Dart Class wizard.
 */
class ClassCreator extends WebComponent {
  
  @observable
  String Name = "";
  
  @observable
  String Properties = "";
  
  @observable
  String Methods = "";
  
  @observable
  String Observables = "";
  
  @observable
  String SourceCode = "";
  
  @observable
  String classType = "Normal";
  
  ClassCreator(){
  }
  
  /***
   * Create the output source code and diagram.
   */
  void Update()
  {

    if (Name.length==0) return;
    
    // Canvas work.
    CanvasElement ca = query("#cdiag");
    int cursor = 34;
    
    int diagwidth = 200;
    int halfwidth = (diagwidth/2).floor();
    int leftmargin = 5;
    int props = 0;
    
    // Draw The Main Boxes.
    ca.context2d.fillStyle = "#f8f8f8";
    ca.context2d.fillRect(0, 0, 999, 999);
    ca.context2d.textAlign = 'center';
    
    ca.context2d.fillStyle = "#000000";
    ca.context2d.font = "bold 12pt Courier";
    ca.context2d.fillText(Name, leftmargin + halfwidth, 18, 100);
    
    ca.context2d.font = "8pt Courier";
    ca.context2d.textAlign = 'left';
    ca.context2d.strokeRect(leftmargin, 5, diagwidth, 20, 1);
    ca.context2d.strokeRect(leftmargin, 25, diagwidth, 75, 1);
    ca.context2d.strokeRect(leftmargin, 100, diagwidth, 75, 1);

    // Only show and compose observables if a Web UI class.
    DivElement wuo = query("#webuionly");
    if (wuo!=null){
      
      if (classType=="Web"){
        wuo.style.visibility = "visible";
      }
      else
        wuo.style.visibility = "hidden";
    }
    
    // Skeleton Code.
    SourceCode ="";
    SourceCode += "/**\r\n";
    SourceCode += "* The class $Name ... TODO\r\n";
    SourceCode += "*/\r\n";
    
    SourceCode += "class $Name ";
    if (classType=="Web"){
      SourceCode = "import 'package:web_ui/web_ui.dart';\r\n\r\n" + SourceCode;
      SourceCode += "extends ";
      SourceCode += "WebComponent ";
    }
    SourceCode += "{";
    
    SourceCode += "\r\n\r\n";
    
    //Add regular properties
    num pos = 0;
    var shortHand = [];
    
    if (Properties.length>0){
      for (String prop in Properties.split(' '))
        if (prop.length>0){ 
          
          shortHand = transformShorthand(prop);
          SourceCode += "  ${shortHand[0]} ${shortHand[1]}${shortHand[2]};\r\n";
          
          //cursor
          if (props<6){
            
            if (props!=5)
              ca.context2d.fillText(shortHand[1], leftmargin*2, cursor);
            else
              ca.context2d.fillText("...", leftmargin*2, cursor);
            cursor +=11;
            props++;
          }
        }
          
    }
    
    // Add Observable properties
    if (classType=="Web"){
      if (Observables.length>0){
        for (String obs in Observables.split(' '))
          if (obs.length>0){
            SourceCode += "  \r\n";
            SourceCode += "  @observable\r\n";
            shortHand = transformShorthand(obs);
            SourceCode += "  ${shortHand[0]} ${shortHand[1]}${shortHand[2]};\r\n";                 
          }
      }
    }
    
    // CTOR and methods
    SourceCode += "\r\n";
    SourceCode += "  ///TODO Ctor";
    
    SourceCode += "\r\n";
    SourceCode += "  $Name(){}";
    
    SourceCode += "\r\n\r\n";
    
    cursor = 109;
    props = 0;
    if (Methods.length>0){
      for (String method in Methods.split(' ')){
       
        shortHand = transformShorthand(method);
        method = "${shortHand[0]} ${shortHand[1]}";
        if (method.length>0){
          SourceCode += "  $method(){}\r\n\r\n";
          if (props<6){
            
            if (props!=5)
              ca.context2d.fillText(shortHand[1], leftmargin*2, cursor);
            else
              ca.context2d.fillText("...", leftmargin*2, cursor);
            cursor +=11;
            props++;
          }

        }
        
      }
    }
    
    SourceCode += "}";
    
  }
  
  /// Exand Shorthand property to the real deal.
  List transformShorthand(String Shortie){
    
    var pos = Shortie.indexOf('.');
    var identifier = "";
    var type = "";
    var initvalue = "";
    
    if(pos>0){
      type = Shortie.split('.')[0];
      identifier = Shortie.split('.')[1];
      pos = identifier.indexOf('=');
      
      if (pos>-1){
        var unprocid = identifier;
        identifier = identifier.split('=')[0];
        initvalue = " = " + (unprocid.split('=')[1].trim());
      }
      
    }else{
      type = "var";
      identifier = Shortie;
    }
    
    var o = new List()
        ..add(type)
        ..add(identifier)
        ..add(initvalue);
    return o;
  }
}
