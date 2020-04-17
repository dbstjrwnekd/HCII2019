﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class plane2Scripts : MonoBehaviour {
	private string objectName = "plane";

	static int num_frame = 0;
	static int speed = 1000;

	enum State
	{
		Idle,
		Hit
	}

	State currentState;

	// Use this for initialization
	void Start () {
		currentState = State.Idle;
		NextState();
	}

	// Update is called once per frame
	void Update () {
		num_frame++;

		if(num_frame == 3500)
		{
			float translation = Input.GetAxis("Vertical");

			translation = translation * Time.deltaTime + speed;
			transform.Translate(0, translation, 0);
		}
	}

	public string Hit()
	{
		if (currentState == State.Hit)
		{
			return objectName;
		}
		else
		{
			currentState = State.Hit;
			return objectName;
		}

	}

	IEnumerator IdleState()
	{
		this.gameObject.transform.rotation = Quaternion.identity;

		while (currentState == State.Idle)
		{
			yield return null;
		}

		NextState();
	}


	IEnumerator HitState()
	{

		float hitTime = 0.5f;


		while (currentState == State.Hit)
		{
			yield return null;

			if (hitTime <= 0)
			{
				this.currentState = State.Idle;
			}
			hitTime -= Time.deltaTime;
		}

		NextState();
	}

	void NextState()
	{
		switch (currentState)
		{
		case State.Idle:
			StartCoroutine(IdleState());
			break;
		case State.Hit:
			StartCoroutine(HitState());
			break;
		}
	}
}