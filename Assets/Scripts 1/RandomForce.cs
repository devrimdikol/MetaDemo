using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomForce : MonoBehaviour
{
	public Rigidbody rb;
	public float timer;
	public float duration= 2f;
	public Vector3 torque;
	public Vector3 force;
	public float torqueAmount = 10f;
	public float forceAmount = 10f;
	public float _forceAmount = 1f;
	// Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
	void FixedUpdate()
	{
		timer += Time.fixedDeltaTime;
		if ( timer>duration) {
			
			timer = 0f;
			torque = new Vector3( Random.Range(-1f,1f),  Random.Range(-1f,1f), Random.Range(-1f,1f) );
			force = new Vector3( Random.Range(-1f,1f),  Random.Range(-1f,1f), Random.Range(-1f,1f) );
			_forceAmount = Random.Range(-1f,1f);
		} else  {

			torque = Vector3.zero;
			force = Vector3.zero;
			_forceAmount = Random.Range(-1f,1f);

		}
		
		rb.AddTorque(torque*torqueAmount);
		//		rb.AddForce(transform.forward*forceAmount*_forceAmount);
		rb.AddForce(force*forceAmount);
    }
}
