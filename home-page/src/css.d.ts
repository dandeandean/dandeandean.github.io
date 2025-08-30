// Without this we get CSS warnings
declare module '*.css' {
  const content: { [className: string]: string };
  export default content;
}
