using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RelativeMotion : MonoBehaviour
{
	public  Transform master;
	public float smoothTime = 0.3F;
	private Vector3 velocity = Vector3.zero;

	private Vector3 impactPosOffset;
	private Vector3 impactRotOffset;
 
	
    // Start is called before the first frame update
    void Start()
    {
	    impactPosOffset = transform.position-master.position; //where were we relative to it?
	    impactRotOffset = transform.eulerAngles-master.eulerAngles; //
    }

    // Update is called once per frame
    void Update()
	{
		transform.position = master.position+impactPosOffset; //move to where the stuck object is, plus the offset
		transform.eulerAngles = master.eulerAngles+impactRotOffset;//rotate to where the stuc
    	
    }
}
