using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CameraFocusManager : MonoBehaviour
{
	public GameObject camera;
	public GameObject focusObject;
	public float focusObjectMaxRotationSpeed = 60;
	public GameObject [] focusPoints;
	Vector3 targetPos;
	Quaternion targetRot;
	
	Vector3 vel = Vector3.zero;
	//Vector3 rotVel = 0;
	
	int targetIndex = 0;
	float curRotSpd = 0;
	float rotVel = 0;
	
	//public HumanBodyGeneratorUIHelper generatorUIHelper;
	
	bool firstFrame = true;
	// Start is called before the first frame update
    void Start()
    {
	    SetTarget(0);
    }
    
	public int GetTargetIndex()
	{
		return targetIndex;
	}
    
	public void SetTarget(int i)
	{
		targetIndex = i;
		//if(generatorUIHelper != null)
		//	generatorUIHelper.FilterByFocusObject(focusPoints[i].GetComponent<CameraFocusBodyPart>());
		//targetPos = focusPoints[i].transform.position;
		//targetRot = focusPoints[i].transform.rotation;
	}
	
	void MoveCamera()
	{
		camera.transform.position = Vector3.SmoothDamp(camera.transform.position, focusPoints[targetIndex].transform.position, ref vel, 1, 20);
		camera.transform.rotation = Quaternion.Slerp(camera.transform.rotation, focusPoints[targetIndex].transform.rotation, Time.deltaTime);
	}
	
	void RotateFocusObject()
	{
		float dir = 0;
		
		if(Input.mousePosition.x > Screen.width*.5)
		{
			if(Input.GetMouseButton(0))
			{
				dir = Mathf.Clamp(Input.GetAxis("Mouse X"), -1, 1);	
			}
		}
		
		if(Input.GetKey(KeyCode.LeftArrow))
			dir = -0.3f;
		if(Input.GetKey(KeyCode.RightArrow))
			dir = 0.3f;
		
		
		curRotSpd = Mathf.SmoothDamp(curRotSpd, -dir*focusObjectMaxRotationSpeed, ref rotVel, 0.3f);

		if(focusObject != null)
		{
			focusObject.transform.RotateAround(transform.position, Vector3.up, curRotSpd);	
		}
		
	}

    // Update is called once per frame
    void Update()
    {
        
	    if(firstFrame)
	    {
	    	firstFrame = false;
	    	SetTarget(0);
	    	return;
	    }
        
        
	    MoveCamera();
        
	    RotateFocusObject();
	    
	    //
	    /*if(Input.GetKeyUp("u"))
	    {
	    	if(uiGameObject != null)
	    		uiGameObject.SetActive(!uiGameObject.active);
	    }*/
	    //Debug.Log("osman");
	    
	    
        
    }
}
