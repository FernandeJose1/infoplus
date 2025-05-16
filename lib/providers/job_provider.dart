import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/job.dart';

class JobProvider extends ChangeNotifier {
  final _jobsRef = FirebaseFirestore.instance.collection('jobs');
  List<Job> _jobs = [];

  List<Job> get jobs => _jobs;

  Future<void> fetchJobs(String province) async {
    final snapshot = await _jobsRef.where('location', isEqualTo: province).get();
    _jobs = snapshot.docs.map((doc) => Job.fromJson(doc.data())).toList();
    notifyListeners();
  }

  List<Job> jobsByProvince(String province) {
    return _jobs.where((job) => job.location == province).toList();
  }

  Future<void> addJob(Job job) async {
    await _jobsRef.doc(job.id).set(job.toJson());
    await fetchJobs(job.location);
  }

  Future<void> deleteJob(String id) async {
    await _jobsRef.doc(id).delete();
    _jobs.removeWhere((j) => j.id == id);
    notifyListeners();
  }
}