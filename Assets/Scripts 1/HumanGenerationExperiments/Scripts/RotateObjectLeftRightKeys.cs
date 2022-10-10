using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RotateObjectLeftRightKeys : MonoBehaviour
{
	public float maxRotationSpeed = 60;
	
	float rotVel = 0;
	float curRotSpd = 0;
	// Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
	    
	    
	    
	    float dir = 0;
	    
	    if(Input.GetKey(KeyCode.X))
	    	dir = 1;
	    if(Input.GetKey(KeyCode.C))
	    	dir = -1;
	    	
	    //Debug.Log(dir + " , " + curRotSpd);
	    curRotSpd = Mathf.SmoothDamp(curRotSpd, dir*maxRotationSpeed, ref rotVel, 0.3f);
	    
	    transform.RotateAround(transform.position, Vector3.up, curRotSpd * Time.deltaTime);
    }
}
