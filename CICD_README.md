# CI/CD Pipeline Documentation for ENSF 400 Project

## Overview

This project aims to build an automated Continuous Integration/Continuous Deployment (CI/CD) pipeline for an open-source sample application: **https://github.com/7ep/demo** using GitHub, Docker, and Jenkins. The goal is to validate every code change automatically through container builds, unit tests, code quality checks, and end-to-end functional tests.

We have established a workflow for managing the project on GitHub, containerizing the application with Docker, and integrating Jenkins for CI/CD automation. This document provides instructions on how to replicate the environment, set up the project, and use the CI/CD pipeline.

## GitHub Workflow and Collaboration

We manage our project using GitHub with the following branching strategy for smooth collaboration:

1. **Forking and Cloning**:
   - We forked the original project repository and used github **codespaces** to work on the project.
   - Another alternative is to clone the repository  by simply using the command:
     ```bash
     git clone https://github.com/not-yvonne/400_project.git
     ```

2. **Branching Strategy**:
   - **master branch**: Stable code, ready to be deployed.
   - **develop branch**: Ongoing development branch, where all feature branches are merged before going into production.
   - **< feature > branches**: Individual feature implementations created from the develop branch.

3. **Collaboration Process**:
   - A team member works on a feature branch created from **develop**.
   - To create a new feature branch, run:
     ```bash
     git checkout -b <feature-branch-name>
     ```
   - After completing the feature, push the branch and create a pull request (PR) to merge the changes back into **develop**:
     ```bash
     git push origin <feature-branch-name>
     ```
   - **Code Review Process**: The pull request is reviewed by at least one other team member before it is merged into **develop**. Once the features are fully integrated, **develop** is merged into **master** when ready for deployment.

   - We are using pull requests to facilitate code reviews before merging. This ensures that all code is reviewed and tested by the team before it’s integrated into the main branches.

## Environment Setup

To ensure compatibility with the original application, we set up the following development environment:

1. **JDK 11** and **Gradle 7** are used to build and run the application. Ensure that these versions are installed and configured correctly on your development machine or Codespace.

    - To install **Gradle 7** in your Codespace, run:
      ```bash
      sdk install gradle 7.6.4
      ```
    - Verify the versions by running:
      ```bash
      java --version
      gradle --version
      ```

2. Update the `org.gretty` version in the `build.gradle` file:
   ```groovy
   id 'org.gretty' version '3.0.4' // change to
   id 'org.gretty' version '3.1.5'
   ```
---

## Containerization

To ensure consistent builds and deployments, we containerized the application using Docker. Below are the steps to set up the containerization for the project:

### 1. **Build the WAR File**:
   First, use Gradle to build the application and generate the WAR file:
   ```bash
   ./gradlew build
   ```

### 2. **Create the Dockerfile**:
   We created a Dockerfile that uses:

- the **gradle:7.6.1-jdk11** base image to build the application.
- a Tomcat image to deploy the WAR file.

### 3. **Build and Tag the Docker Image**

After creating the Dockerfile, you can build the Docker image and tag it with a unique commit hash.

1. **Build the Docker Image**:
   Run the following command to build the Docker image:
   ```bash
   docker build -t <username>/400_project .
    ```

2. **Tag the Docker Image**:
   To uniquely tag the image, use the commit hash of your latest commit. Run the following command to get the commit hash:
   ```bash
   COMMIT_HASH=$(git rev-parse --short HEAD)
   ```

    Then, tag the image with the commit hash:

    ```bash
    docker tag <username>/400_project <username>/400_project:$COMMIT_HASH
    ```

### 4. **Push the Docker Image to Docker Hub**

After building and tagging the image, we push it to Docker Hub for storage and deployment.

1. **Log in to Docker Hub**:

    ```bash
    docker login -u <username>
    ```
2. **Push the image to Docker Hub**:

    ```bash
    docker push <username>/400_project:latest
    docker push <username>/400_project:$COMMIT_HASH
    ```

### 5. **Run the Docker Image**

After pushing the image, we test it by pulling it from Docker Hub and running it locally:

1. **Pull the docker image**:
    ```bash
    docker pull <username>/400_project:$COMMIT_HASH
    ```

2. **Run the docker image**:
    ```bash
    docker run -p 8080:8080 <username>/400_project:$COMMIT_HASH
    ```

3. **You can verify that the application is running by visiting**:

    **http://localhost:8080/**