using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LevelUtilities : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
    
	    if ( Input.GetKeyDown("r")) {
	    	//Application.LoadLevel(Application.loadedLevel);
		    SexManager[] sms = GameObject.FindObjectsOfType<SexManager>();
		    foreach ( SexManager sm in sms) {
		    	sm.Reset();
		    }
		    
	    }

	    if ( Input.GetKeyDown("x")) {
		   
	    }


    }
}
