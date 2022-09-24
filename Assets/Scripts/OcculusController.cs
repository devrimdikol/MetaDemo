using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class OcculusController : MonoBehaviour
{
    public GameObject LeftController;
    public GameObject RightController;

    private Vector3 prevLeftControllerPosition;
    private Vector3 prevRightControllerPosition;

    public Animator MaleAnimator;
    public Animator FemaleAnimator;

    public float Speed = 0.0f;

    public GameObject MaleLeftEye;
    public GameObject MaleRightEye;

    public GameObject OcculusCamera;

    private Vector3 cameraOffset = Vector3.zero;

    // Start is called before the first frame update
    void Start()
    {
        prevLeftControllerPosition = LeftController.transform.position;
        prevRightControllerPosition = RightController.transform.position;

        Vector3 eyeMidPosition = 0.5f * (MaleLeftEye.transform.position + MaleRightEye.transform.position);
        cameraOffset = OcculusCamera.transform.position - eyeMidPosition;
    }

    // Update is called once per frame
    void Update()
    {
        Vector3 leftControllerDiff = LeftController.transform.position - prevLeftControllerPosition;
        Vector3 rightControllerDiff = RightController.transform.position - prevRightControllerPosition;

        float totalDiffX = leftControllerDiff.magnitude + rightControllerDiff.magnitude;

        float targetSpeed = Mathf.Clamp(Mathf.Abs(totalDiffX) * 8000.0f * Time.deltaTime, 0.0f, 1.5f);

        Speed = Mathf.Lerp(Speed, targetSpeed, 0.1f);

        prevLeftControllerPosition = LeftController.transform.position;
        prevRightControllerPosition = RightController.transform.position;

        MaleAnimator.SetFloat("Speed", Speed);
        FemaleAnimator.SetFloat("Speed", Speed);

        Vector3 eyeMidPosition = 0.5f * (MaleLeftEye.transform.position + MaleRightEye.transform.position);

        OcculusCamera.transform.position = eyeMidPosition;// + cameraOffset;

    }
}
