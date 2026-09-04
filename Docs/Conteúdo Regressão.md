* Objetivo da Análise de Regressão: Encontrar a relação entre uma variável $Y$, Variável de Interesse| Variável Resposta e a Variávei Explicativa|Variável Preditora.
A ideia principal é que a variável $Y$ segue uma distribuição com $\mu \text{ e } \sigma$ fixos $Y \sim D(\mu, \sigma^2)$ e $\mu$ é representada por uma reta: $$Y_i = \beta_1 + \beta_2 x_i + \varepsilon_i$$
o $\varepsilon_{i}$: representa a distância (vertical) real até a reta . Assumimos que esses erros são independentes, têm média 0 e var constante ($\sigma^2$).

--- 
* *Forma Quadráticas*: Expressões do tipo $Q = x^TAx$. Se $A$ for uma matriz simétrica positiva definida, significa que todas as suas raízes características (autovalores) são estritamente positivas e que $x^TAx > 0$ para qualquer $x \neq 0$.
$$f'(x) = (a^Tx)'= a$$
A derivada da forma quadrática $$f'(x)=({x^TAx}) '= 2Ax$$
* **Esperança de uma Forma Quadrática** Se você tem um vetor aleatório $v$ com média $m$ e matriz de covariância $C$, o valor esperado de $v^TWv$ (sendo $W$ uma matriz de constantes) é dado por: $$E(v^TWv) = \text{tr}(WC) + m^TWm$$ _(Onde_ o traço é a soma dos elementos da diagonal principal da matriz)
* **Notação matricial** do modelo de regressão:$$Y_{p\times_{1}} = X_{n\times p}\beta_{p\times_{1}} + \varepsilon_{n\times_{1}}$$ (Note que são tamanho das matrizes, não os índices)
$X$ é chamada de **Matriz de Delineamento (Design Matrix)**. Ela guarda os dados das variáveis preditoras. A primeira coluna é toda preenchida com o número $1$ para multiplicar pelo intercepto $\beta_1$.
e $\varepsilon$ e o vetor de erros, **assumimos que $\varepsilon \sim N_n(0, \sigma^2 I_n)$**. Isso torna o modelo um Modelo de Regressão Linear Normal (MRN), o que significa que $Y \sim N_n(X\beta, \sigma^2 I_n)$.
$$\varepsilon \sim N_n(0, \sigma^2 I_n)$$
* Fómula do Estimador de MQO: $$\hat{\beta} = (X^TX)^{-1}X^TY$$
Condição: esse estimador só existe se a matriz $(X^TX)$ for invertível, o que exige que as colunas de $X$ sejam linearmente independentes (posto completo).
---
* Resíduos:$$e = (I_n - H)Y$$onde $H = X(X^TX)^{-1}X^T$ é a chamada Matriz Chapéu(Hat Matrix), que projeta $Y$ no espaço estimado.
* Propriedades cruciais dos resíduos:
- Média esperada: $E(e_i) = 0$
- Variância: $Var(e_i) = \sigma^2 (1 - h_{ii})$ ( no quiz apareceu $Var( ϵ )=\sigma^2I_{n}$  pois ϵ é o erro aleatório observável, não $VAR(e)$, matriz de covariâncias dos resíduos observáveis)
- Covariância entre resíduos diferentes: $Cov(e_i, e_j) = -\sigma^2 h_{ij}$
---
O Método da Máxima Verossimilhança busca os valores dos parâmetros que maximizam a probabilidade de termos observado a amostra. Ela assume que os erros são normais.
$\hat{\beta}_{EMV} = (X^TX)^{-1}X^TY$) ela estima os betas exatamente igual ao MQO e o $\sigma^2$ é $$\hat{\sigma}^2_{EMV} = \frac{e^Te}{n}$$ ( ele é viesado em amostra pequena pois divide por $n$, ao invés de $n-p$, que é o da MQO)

💡 **Dica da IA para a prova:** Lembre-se de que a distribuição amostral de $\hat{\beta}$ sob normalidade é dada por $\hat{\beta} \sim N_p(\beta, \sigma^2 (X^TX)^{-1})$. Isso significa que se o professor pedir para testar hipóteses ou construir intervalos de confiança para combinações lineares de coeficientes ($a^T\beta$), a variância associada virá do termo $a^T(X^TX)^{-1}a$! 

---
$$\sigma^2=\frac{e^Te}{n-p}$$