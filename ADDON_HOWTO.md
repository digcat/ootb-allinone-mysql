Example of adding an addon build
================================

Using the example of the zaizi-alfresco-recommendations extension


* First you need to make a puppet module under buildmodules/ which will build your extension
    * e.g. https://github.com/marsbard/ootb-allinone-mysql/blob/master/buildmodules/zaizi-alfresco-recommendations/manifests/init.pp
* Then you need a puppet module under modules, prefixed “addons-” to copy the amps into place prior to running “apply_amps.sh”
    * In this case, addons-zaizi-alfresco-recommendations has configuration at 
      https://github.com/marsbard/ootb-allinone-mysql/blob/master/modules/addons-zaizi-alfresco-recommendations/manifests/init.pp
* Finally you need to add an include such as (e.g.) ‘include “addons-zaizi-alfresco-recommendations”’ to https://github.com/marsbard/ootb-allinone-mysql/blob/master/modules/addons/manifests/init.pp

