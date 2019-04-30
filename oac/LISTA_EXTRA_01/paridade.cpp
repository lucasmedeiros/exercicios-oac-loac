#include <iostream>
using namespace std;

int* getDadosEnviados(int* dados) {
  cout << "Digite 4 bits de dados enviados na transmissão um por um:" << endl;
  
  for (int i = 0; i <= 4; i++) {
    if (i == 3) {
      continue;
    }

    cout << "Bit " << (i + 1) << ": ";
    cin >> dados[i];
  }

  return dados;
}

int* getDadosRecebidos(int* dados) {
  cout << "Digite os bits dos dados recebidos na transmissão um por um:" << endl;

  for (int i = 0; i < 7; i++) {
    cout << "Bit" << (i + 1) << ": ";
    cin >> dados[i];
  }

  return dados;
}

void calculaParidade(int* dados) {
  dados[6] = dados[0] ^ dados[2] ^ dados[4];
  dados[5] = dados[0] ^ dados[1] ^ dados[4];
  dados[3] = dados[0] ^ dados[1] ^ dados[2];
}

void imprimeArrayBits(int* dados, int tamanho) {
  for (int i = 0; i < tamanho; i++) {
    cout << dados[i];
  }

  cout << endl << endl;
}

void imprimeResultado(int* enviados, int* recebidos, int tamanho) {
  bool iguais = true;
  int i = 0;

  while(enviados[i] == recebidos[i] && i < tamanho) {
    i++;
  }

  if (i == tamanho) {
    cout << "Nenhum erro detectado na transmissão!" << endl;
  } else {
    cout << "Erro detectado!" << endl;

    cout << "Dados enviados: " << endl;
    imprimeArrayBits(enviados, 7);

    cout << "Dados recebidos: " << endl;
    imprimeArrayBits(recebidos, 7);
  }
}

int main() {
  int dadosEnviados[7];
  int* ponteiroDadosEnviados = getDadosEnviados(dadosEnviados);
  calculaParidade(ponteiroDadosEnviados);

  cout << "Dados codificados:" << endl;
  imprimeArrayBits(ponteiroDadosEnviados, 7);

  int dadosRecebidos[7];
  int* ponteiroDadosRecebidos = getDadosRecebidos(dadosRecebidos);

  imprimeResultado(ponteiroDadosEnviados, ponteiroDadosRecebidos, 7);

  return 0;
}