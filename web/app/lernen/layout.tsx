export default function LernenLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <>
      <script
        dangerouslySetInnerHTML={{
          __html: `(function(){try{if(localStorage.getItem("lernarena-theme")==="light"){document.documentElement.setAttribute("data-theme","light");}}catch(e){}})();`,
        }}
      />
      {children}
    </>
  );
}
