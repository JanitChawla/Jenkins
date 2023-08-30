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
