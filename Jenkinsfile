// pipeline {
//     agent any

//     environment {
//         DOCKERHUB_CREDENTIALS = credentials('dockerhub')
//     }

//     stages {
//         stage('Checkout Source') {
//             steps {
//                 sh 'git clone https://github.com/janit-chawla/notejam.git'
//             }
//         }

//         stage('Login') {
//             steps {
//                 sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
//             }
//         }

//         stage('Build image') {
//             steps{
//                 sh 'docker build -t janit31/my-notejam --no-cache .'
//             }
//         }
//         stage('Pushing') {
//             steps{
//                 sh 'docker push janit31/my-notejam'
//             }
//         }
//          stage("Start Config Maps") {
//             steps {
//                       sh "kubectl apply -f /var/lib/jenkins/workspace/Notejam-pipeline/Notejam-Jenkins/config.yaml"
//             }
//         }
//         stage("Start Database") { 
//             steps {
//                       sh "kubectl apply -f /var/lib/jenkins/workspace/Notejam-pipeline/Notejam-Jenkins/postgres-deploy.yml"
//             }
//         }
//          stage("Start Application") {
//             steps {
//                       sh "kubectl apply -f /var/lib/jenkins/workspace/Notejam-pipeline/Notejam-Jenkins/notejam-application-deploy.yml"
//             }
//         }
//         stage("Minikube Service List") {
//             steps {
//                       sh "kubectl get services"
//             }
//         }

//     }
// }

 
pipeline{
    environment{
        dockerimagename = "janit31/my-notejam"
        dockerImage =""
        registrycredentials = 'dockerhub'
    }
    agent any
    stages {
        stage('Checkout Source'){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/janit-chawla/notejam.git'
            }
        }
        stage('Build Image'){
            steps {
                script{
                    dockerImage = docker.build dockerimagename
                }
            }
        }
        stage('Pushing Image'){
            steps{
                script{
                    docker.withRegistry('https://hub.docker.com/', registrycredentials){
                        dockerImage.push("latest")
                    }
                }
            }
        }
        stage('Deploying'){
            steps{
                scripts{
                    kubernetesDeploy(configs: 'deployment.yaml','persistentvolume.yaml','persistentvolumeclaim','postgres-deploy.yaml','postgres-secret.yaml','postgres-service.yaml')
                }
            }
        }

    }
}
