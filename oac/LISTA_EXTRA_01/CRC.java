import java.util.ArrayList;
import java.util.Scanner;

public class CRC {

	static Scanner teclado = new Scanner(System.in);

	@SuppressWarnings("unchecked")
	public static ArrayList<String> deslocaEsquerda(ArrayList<String> dados, int quant){
		ArrayList<String> toReturn = (ArrayList<String>) dados.clone();

		//desloca os dados para a esquerda  o n vezes, sendo n o tamanho do gerador mais 1
		for (int i = 0; i < quant; i++) {
			toReturn.add("0");
		}
		
		return toReturn;
	}
	
	public static ArrayList<String> dividePolinomialmente(ArrayList<String> dividendo, ArrayList<String> divisor){
		
		for(int index = 0; ((dividendo.size() - index) >= divisor.size()); index++) {
			if(dividendo.get(index).equals("1")) {
				int indexP = index;
				for (int i = 0; i < divisor.size(); i++) {
					if(divisor.get(i).equals(dividendo.get(indexP))) {
						dividendo.set(indexP, "0");
					}
					else {
						dividendo.set(indexP, "1");
					}
					indexP++;
				}
			}
		}
		
		return dividendo;
	}

	public static ArrayList<String> geraCRC(ArrayList<String> dados, ArrayList<String> gerador) {
		ArrayList<String> result = dividePolinomialmente(deslocaEsquerda(dados, gerador.size()-1), gerador); 
		
		
		ArrayList<String> CRC = new ArrayList<>();
		
		for (int i = dados.size(); i < result.size(); i++) {
			CRC.add(result.get(i));
		}
		
	
		return CRC;
	}
	
	public static boolean verificaDadosRecebidos(ArrayList<String> dados, ArrayList<String> gerador) {
		ArrayList<String> result = dividePolinomialmente(dados, gerador);
		
		boolean toReturn = true;
		for(String bit: result) {
			if(bit.equals("1")) {
				toReturn = false;
				break;
			}
		}
		
		return toReturn;
	}

	public static ArrayList<String> entradaToArray(String entrada){
		ArrayList<String> toReturn = new ArrayList<>();
		for (int i = 0; i < entrada.length(); i++) {
			toReturn.add(entrada.substring(i, i+1));
		}

		return toReturn;
	}
	
	public static String arrayToString(ArrayList<String> array) {
		String toReturn = "";
		for(String bit : array) {
			toReturn += bit;
		}
		
		return toReturn;
	}

	public static void main(String[] args) {
		

		System.out.print("Digite a sequência de dados: ");
		String dados = teclado.nextLine();
		System.out.print("Digite o código gerador: ");
		String gerador = teclado.nextLine();

		System.out.print("O código CRC gerado foi: ");
		
		String CRC = arrayToString(geraCRC(entradaToArray(dados), entradaToArray(gerador)));
		
		System.out.println(CRC);
		
		System.out.print("Os dados enviados foram: ");
		
		System.out.println(dados + CRC);
		
		System.out.print("Digite a sequência de dados recebidos: ");
		String dadosRecebidos = teclado.nextLine();

		boolean verificacao = verificaDadosRecebidos(entradaToArray(dadosRecebidos), entradaToArray(gerador));
		
		if(verificacao) {
			System.out.println("OS DADOS RECEBIDOS ESTÃO CORRETO");
		} else {
			System.out.println("OCORREU ERRO NA TRANSMISSÃO DOS DADOS, POR FAVOR ENVIE NOVAMENTE");
		}
		
	}

}
