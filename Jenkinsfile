pipeline{
    environment{
        dockerimagename = "janit31/my-notejam"
        dockerImage =""
        DOCKERHUB_CREDENTIALS = credentials('dockerhub')
    }
    agent any
    stages {
        stage('Checkout Source'){
            steps{
                git branch: 'main', credentialsId: 'github', url: 'https://github.com/janit-chawla/notejam.git'
            }
        }
        stage('Login') {
            steps {
                sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'
            }
        }
        stage('Build Image'){
            steps {
                sh 'docker build -t janit31/my-notejam --no-cache .'
            }
        }
        stage('Pushing Image'){
            steps{
                sh 'docker push janit31/my-notejam'
            }
        }
        stage('Databse'){
            steps{
                sh 'kubectl apply -f postgres-secret.yaml'
                sh 'kubectl apply -f postgres-deploy.yaml'
                sh 'kubectl apply -f postgres-service.yaml'
            }
        }
        stage("Notejam"){
            steps{
                sh 'kubectl apply -f persistentvolume.yaml'
                sh 'kubectl apply -f persistentvolumeclaim.yaml'
                sh 'kubectl apply -f deployment.yaml'
            }
        }

    }
    post {
    always {
      sh 'docker logout'
    }
  }
}
