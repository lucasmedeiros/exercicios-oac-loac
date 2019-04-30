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

int calculaCoeficiente(int* dadosRecebidos) {
  int c1 = dadosRecebidos[6] ^ dadosRecebidos[4] ^ dadosRecebidos[2] ^ dadosRecebidos[0];
  int c2 = dadosRecebidos[5] ^ dadosRecebidos[3] ^ dadosRecebidos[1] ^ dadosRecebidos[0];
  int c3 = dadosRecebidos[3] ^ dadosRecebidos[2] ^ dadosRecebidos[1] ^ dadosRecebidos[0];

  return c3*4 + c2*2 + c1;
}

void corrige(int* recebidos, int c) {
  if (recebidos[7 - c] == 0) {
    recebidos[7 - c] = 1;
  } else {
    recebidos[7 - c] = 0;
  }
}

void imprimeResultadoHamming(int c, int* enviados, int* recebidos) {
  if (c == 0) {
    cout << "Nenhum erro detectado na transmissão!" << endl;
  } else {
    cout << "Erro detectdo!" << endl;

    cout << "Dados enviados: " << endl;
    imprimeArrayBits(enviados, 7);

    cout << "Dados recebidos: " << endl;
    imprimeArrayBits(recebidos, 7);

    cout << "A mensagem correta é: " << endl;
    corrige(recebidos, c);
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

  int c = calculaCoeficiente(ponteiroDadosRecebidos);
  imprimeResultadoHamming(c, ponteiroDadosEnviados, ponteiroDadosRecebidos);

  return 0;
}
